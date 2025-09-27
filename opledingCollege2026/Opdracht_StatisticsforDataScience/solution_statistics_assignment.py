
# =====================================================================================
# COMPLETE STEP-BY-STEP PYTHON SOLUTION
# "Eindopdracht Statistics for Data Science" - University/College dataset
#
# Author: Adil Vural
# Date:
#
# How to run:
#   python solution_statistics_assignment.py
#
# Requirements:
#   pip install pandas numpy scipy statsmodels matplotlib
#
# Input:
#   - college_statistics.csv  (same directory or adjust PATH below)
#
# Outputs:
#   - Figures saved in ./figs/
#   - Printed test results and model summaries in console
# =====================================================================================

import os
import math
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt

from scipy import stats
import statsmodels.api as sm
import statsmodels.formula.api as smf
from statsmodels.stats.diagnostic import het_breuschpagan, normal_ad
from statsmodels.stats.outliers_influence import variance_inflation_factor
from statsmodels.stats.outliers_influence import OLSInfluence
from sklearn.metrics import mean_squared_error, confusion_matrix, accuracy_score

# ----------------------------
# CONFIG
# ----------------------------
DATA_PATH = os.path.join(os.path.dirname(__file__), "college_statistics.csv")
FIG_DIR = os.path.join(os.path.dirname(__file__), "figs")
os.makedirs(FIG_DIR, exist_ok=True)

RNG_SEED = 42  # for reproducibility
ESTIMATION_SIZE = 600

# ===========================
# Helper utilities
# ===========================
def savefig(name):
    path = os.path.join(FIG_DIR, name)
    plt.savefig(path, bbox_inches="tight", dpi=150)
    plt.close()
    print(f"[Saved] {path}")

def add_constant(df, cols):
    X = df[cols].copy()
    X = sm.add_constant(X, has_constant="add")
    return X

def vif_dataframe(X):
    # Assumes X already includes a constant.
    vif_data = []
    for i, col in enumerate(X.columns):
        if col == "const":
            continue
        try:
            vif_val = variance_inflation_factor(X.values, i)
        except Exception:
            vif_val = np.nan
        vif_data.append({"feature": col, "VIF": vif_val})
    return pd.DataFrame(vif_data)

def backward_elimination_ols(df, response, predictors, p_threshold=0.05, verbose=True):
    """
    Backward elimination using p-values (largest p-value removed each iteration).
    Returns final model and remaining predictors.
    """
    remaining = predictors.copy()
    formula = f"{response} ~ " + " + ".join(remaining) if remaining else f"{response} ~ 1"
    model = smf.ols(formula, data=df).fit()
    while True:
        pvals = model.pvalues.drop("Intercept", errors="ignore")
        if pvals.empty:
            break
        worst = pvals.idxmax()
        if pvals[worst] > p_threshold:
            if verbose:
                print(f"Removing '{worst}' (p={pvals[worst]:.4f})")
            remaining.remove(worst)
            if remaining:
                formula = f"{response} ~ " + " + ".join(remaining)
            else:
                formula = f"{response} ~ 1"
            model = smf.ols(formula, data=df).fit()
        else:
            break
    return model, remaining

def backward_elimination_logit(df, response, predictors, p_threshold=0.05, verbose=True):
    remaining = predictors.copy()
    def fit_logit(cols):
        if cols:
            formula = f"{response} ~ " + " + ".join(cols)
        else:
            formula = f"{response} ~ 1"
        return smf.logit(formula, data=df).fit(disp=False)
    model = fit_logit(remaining)
    while True:
        pvals = model.pvalues.drop("Intercept", errors="ignore")
        if pvals.empty:
            break
        worst = pvals.idxmax()
        if pvals[worst] > p_threshold:
            if verbose:
                print(f"Removing '{worst}' (p={pvals[worst]:.4f})")
            remaining.remove(worst)
            model = fit_logit(remaining)
        else:
            break
    return model, remaining

def qq_plot(residuals, title, fname):
    fig = plt.figure()
    sm.qqplot(residuals, line='45', fit=True)
    plt.title(title)
    savefig(fname)

def cooks_distance_plot(ols_model, title, fname):
    influence = OLSInfluence(ols_model)
    cooks = influence.cooks_distance[0]
    fig = plt.figure()
    plt.stem(np.arange(len(cooks)), cooks, use_line_collection=True)
    plt.xlabel("Observation index")
    plt.ylabel("Cook's distance")
    plt.title(title)
    savefig(fname)

# ===========================
# Deel 1
# ===========================
print("\n===========================")
print("Deel 1: Inlezen & beschrijvende statistiek")
print("===========================\n")

df = pd.read_csv(DATA_PATH)
print("[Info] Data shape:", df.shape)
print(df.head())

# Ensure expected column names (strip dots -> underscores for formulas)
df.columns = [c.replace(".", "_") for c in df.columns]

# Q1(a): Are private universities smaller or larger than public? Define 'size' by F_Undergrad.
# We'll compare distributions of F_Undergrad across Private.
plt.figure()
for label, sub in df.groupby("Private"):
    sub["F_Undergrad"].plot(kind="kde", label=str(label))
plt.xlabel("Full-time undergraduates")
plt.ylabel("Density")
plt.title("Size distribution by Private vs Public (KDE of F_Undergrad)")
plt.legend()
savefig("deel1_a_size_kde.png")

# Also make a boxplot for clarity
plt.figure()
groups = [df.loc[df["Private"]=="Yes", "F_Undergrad"].dropna(),
          df.loc[df["Private"]=="No",  "F_Undergrad"].dropna()]
plt.boxplot(groups, labels=["Private=Yes", "Private=No"])
plt.ylabel("Full-time undergraduates")
plt.title("Size by Private vs Public (Boxplot)")
savefig("deel1_a_size_box.png")

# Q1(b): Are more selective universities more expensive?
# Define selectivity via Acceptance Rate = Accept / Apps. Lower rate => more selective.
# Define 'cost' via Outstate + Room_Board (+ Books + Personal optional).
df["accept_rate"] = df["Accept"] / df["Apps"]
df["total_cost_basic"] = df["Outstate"] + df["Room_Board"]
plt.figure()
plt.scatter(df["accept_rate"], df["total_cost_basic"])
plt.xlabel("Acceptance rate")
plt.ylabel("Total cost (Out-of-state tuition + Room & Board)")
plt.title("Selectivity vs Cost")
savefig("deel1_b_selectivity_vs_cost.png")

# Pearson correlation for a quick numeric summary
sel_cost_corr = stats.pearsonr(df["accept_rate"].dropna(), df["total_cost_basic"].dropna())
print(f"[Deel1(b)] Pearson r(selectivity,cost) = {sel_cost_corr.statistic:.4f}, p={sel_cost_corr.pvalue:.4g}")

# Q1(c): Extra question of our own.
# Example: Is Student/Faculty Ratio lower (i.e., more favorable) at more expensive schools?
plt.figure()
plt.scatter(df["total_cost_basic"], df["S_F_Ratio"])
plt.xlabel("Total cost (Outstate + Room & Board)")
plt.ylabel("Student/Faculty Ratio")
plt.title("Is higher cost associated with lower S/F Ratio?")
savefig("deel1_c_cost_vs_sfratio.png")
corr_sfr = stats.pearsonr(df["total_cost_basic"].dropna(), df["S_F_Ratio"].dropna())
print(f"[Deel1(c)] Pearson r(cost, S/F ratio) = {corr_sfr.statistic:.4f}, p={corr_sfr.pvalue:.4g}")

# Q2: Distribution of Room and Board: compare Normal vs Lognormal using log-likelihood / AIC.
rb = df["Room_Board"].dropna().values
# Fit Normal
mu, sigma = np.mean(rb), np.std(rb, ddof=1)
ll_norm = np.sum(stats.norm.logpdf(rb, loc=mu, scale=sigma))
k_norm = 2  # parameters: mu, sigma
aic_norm = 2*k_norm - 2*ll_norm

# Fit Lognormal: parameterize with underlying normal (meanlog, sdlog)
# scipy's lognorm takes shape=sigma, scale=exp(mu)
shape, loc, scale = stats.lognorm.fit(rb, floc=0)  # force loc=0
ll_logn = np.sum(stats.lognorm.logpdf(rb, s=shape, loc=loc, scale=scale))
k_logn = 2  # shape + scale (loc fixed)
aic_logn = 2*k_logn - 2*ll_logn

print(f"[Deel1] AIC Normal:    {aic_norm:.2f}")
print(f"[Deel1] AIC Lognormal: {aic_logn:.2f}")
best = "Lognormal" if aic_logn < aic_norm else "Normal"
print(f"[Deel1] Best by AIC: {best}")

# Visual fit for the best distribution
plt.figure()
count, bins, _ = plt.hist(rb, bins=30, density=True, alpha=0.5)
x = np.linspace(min(rb), max(rb), 500)
if best == "Normal":
    pdf = stats.norm.pdf(x, loc=mu, scale=sigma)
else:
    pdf = stats.lognorm.pdf(x, s=shape, loc=loc, scale=scale)
plt.plot(x, pdf)
plt.xlabel("Room & Board")
plt.ylabel("Density")
plt.title(f"Room & Board with fitted {best} PDF")
savefig("deel1_roomboard_fit.png")

# QQ-plot for the best distribution
plt.figure()
if best == "Normal":
    sm.qqplot(rb, stats.norm, fit=True, line="45")
    plt.title("QQ-plot Room & Board vs Normal")
else:
    # For lognormal, QQ-plot on log scale against Normal
    sm.qqplot(np.log(rb), stats.norm, fit=True, line="45")
    plt.title("QQ-plot log(Room & Board) vs Normal (Lognormal check)")
savefig("deel1_roomboard_qq.png")

# Q3: Hypothesis tests
# (a) Do elite schools receive a different number of applications than non-elite?
# Define elite as Top10perc > 50
elite = df["Top10perc"] > 50
apps_elite = df.loc[elite, "Apps"].dropna()
apps_non  = df.loc[~elite, "Apps"].dropna()
tt = stats.ttest_ind(apps_elite, apps_non, equal_var=False)  # Welch's t-test
print("\n[Deel1 Hyp (a)] Elite vs Non-elite on Apps (Welch t-test)")
print(f"  mean(elite)={apps_elite.mean():.1f}, mean(non)={apps_non.mean():.1f}")
print(f"  t={tt.statistic:.3f}, p={tt.pvalue:.4g}")

# (b) Is there a relationship between acceptance rate and graduation rate?
grad = df["Grad_Rate"]
valid = df[["accept_rate", "Grad_Rate"]].dropna()
pear = stats.pearsonr(valid["accept_rate"], valid["Grad_Rate"])
print("\n[Deel1 Hyp (b)] Pearson correlation between acceptance rate and graduation rate")
print(f"  r={pear.statistic:.3f}, p={pear.pvalue:.4g}")

# (c) Extra hypothesis: Do private schools have a different graduation rate than public?
gr_priv = df.loc[df["Private"]=="Yes", "Grad_Rate"].dropna()
gr_pub  = df.loc[df["Private"]=="No",  "Grad_Rate"].dropna()
tt_gr = stats.ttest_ind(gr_priv, gr_pub, equal_var=False)
print("\n[Deel1 Hyp (c)] Private vs Public on Graduation Rate (Welch t-test)")
print(f"  mean(private)={gr_priv.mean():.2f}, mean(public)={gr_pub.mean():.2f}")
print(f"  t={tt_gr.statistic:.3f}, p={tt_gr.pvalue:.4g}")

# ===========================
# Deel 2
# ===========================
print("\n===========================")
print("Deel 2: Modellen voor aantal aanmeldingen (Apps)")
print("===========================\n")

# (a) Test normality of Apps
apps = df["Apps"].dropna()
k2 = stats.normaltest(apps)  # D'Agostino K^2
print(f"[Deel2(a)] Normaltest for Apps: statistic={k2.statistic:.3f}, p={k2.pvalue:.4g}")
print("Note: With large N, even small deviations from normality often yield small p-values.")

# (b) Train-test split (estimation/test)
np.random.seed(RNG_SEED)
df_shuffled = df.sample(frac=1, random_state=RNG_SEED).reset_index(drop=True)
est = df_shuffled.iloc[:ESTIMATION_SIZE, :].copy()
test = df_shuffled.iloc[ESTIMATION_SIZE:, :].copy()

print(f"[Split] Estimation={est.shape[0]}, Test={test.shape[0]}")

# (c) Linear model for Apps using ONLY pre-application variables.
# Exclude: Accept, Enroll.
# Candidate predictors:
#   Private (binary), Top10perc, Top25perc, F_Undergrad, P_Undergrad, Outstate,
#   Room_Board, Books, Personal, PhD, Terminal, S_F_Ratio, perc_alumni, Expend, Grad_Rate (exclude! not known pre-apps)
# We exclude Grad_Rate in first models (often an outcome). Keep cost/quality/size variables.
candidate_predictors = [
    "C(Private)", "Top10perc", "Top25perc", "F_Undergrad", "P_Undergrad",
    "Outstate", "Room_Board", "Books", "Personal", "PhD", "Terminal",
    "S_F_Ratio", "perc_alumni", "Expend"
]

formula_all = "Apps ~ " + " + ".join(candidate_predictors)
ols_full = smf.ols(formula_all, data=est).fit()
print("\n[OLS Full]")
print(ols_full.summary())

# (d) Backward elimination
# For formulas with categorical 'C(Private)', treat as a single term in the elimination list
# We'll use patsy coding; here we provide names except we keep "C(Private)" intact.
elim_list = candidate_predictors.copy()
ols_be, kept = backward_elimination_ols(est, "Apps", elim_list, p_threshold=0.05, verbose=True)
print("\n[OLS Backward Elimination Result]")
print(ols_be.summary())
print("[Kept predictors]:", kept)

# (e) Linear model assumptions
# Residual normality (QQ), Homoscedasticity (Breusch-Pagan), VIF, Influential points
resid = ols_be.resid
qq_plot(resid, "OLS Residuals QQ-plot", "deel2_ols_resid_qq.png")

X_be = ols_be.model.exog
bp_lm, bp_pval, _, _ = het_breuschpagan(ols_be.resid, X_be)
print(f"[Breusch-Pagan] LM stat={bp_lm:.3f}, p={bp_pval:.4g}")

# VIF (build dataframe from exog names)
vif_df = vif_dataframe(pd.DataFrame(X_be, columns=ols_be.model.exog_names))
print("\n[VIF]")
print(vif_df)

cooks_distance_plot(ols_be, "Cook's distance (OLS BE)", "deel2_ols_cooks.png")

# (f) Log-Apps model (log1p to handle zero safely if any)
est["log_Apps"] = np.log1p(est["Apps"])
test["log_Apps"] = np.log1p(test["Apps"])

formula_all_log = "log_Apps ~ " + " + ".join(candidate_predictors)
ols_log_full = smf.ols(formula_all_log, data=est).fit()
print("\n[OLS Log Full]")
print(ols_log_full.summary())

# (g) Backward elimination for log model
ols_log_be, kept_log = backward_elimination_ols(est, "log_Apps", candidate_predictors.copy(), p_threshold=0.05, verbose=True)
print("\n[OLS Log Backward Elimination Result]")
print(ols_log_be.summary())
print("[Kept predictors - log model]:", kept_log)

# Diagnostics for log model
qq_plot(ols_log_be.resid, "OLS Log Residuals QQ-plot", "deel2_olslog_resid_qq.png")
X_log_be = ols_log_be.model.exog
bp_lm_log, bp_pval_log, _, _ = het_breuschpagan(ols_log_be.resid, X_log_be)
print(f"[Breusch-Pagan LOG] LM stat={bp_lm_log:.3f}, p={bp_pval_log:.4g}")

vif_log_df = vif_dataframe(pd.DataFrame(X_log_be, columns=ols_log_be.model.exog_names))
print("\n[VIF - log model]")
print(vif_log_df)

cooks_distance_plot(ols_log_be, "Cook's distance (OLS LOG BE)", "deel2_olslog_cooks.png")

# (h) Which model preferred? Compare AIC/BIC and residual diagnostics
print("\n[Model Comparison]")
print(f"  OLS BE:     AIC={ols_be.aic:.1f}, BIC={ols_be.bic:.1f}, R2={ols_be.rsquared:.3f}")
print(f"  OLS LOG BE: AIC={ols_log_be.aic:.1f}, BIC={ols_log_be.bic:.1f}, R2={ols_log_be.rsquared:.3f}")

# (i) Try further improvements: log-transform skewed predictors and rebuild a log(Apps) model
for col in ["F_Undergrad", "P_Undergrad", "Expend", "Outstate", "Room_Board", "Books", "Personal"]:
    est[f"log1p_{col}"] = np.log1p(est[col])
    test[f"log1p_{col}"] = np.log1p(test[col])

improved_predictors = [
    "C(Private)", "Top10perc", "Top25perc",
    "log1p_F_Undergrad", "log1p_P_Undergrad",
    "log1p_Outstate", "log1p_Room_Board", "log1p_Books", "log1p_Personal",
    "PhD", "Terminal", "S_F_Ratio", "perc_alumni", "log1p_Expend"
]
ols_log_imp_full = smf.ols("log_Apps ~ " + " + ".join(improved_predictors), data=est).fit()
ols_log_imp_be, kept_imp = backward_elimination_ols(est, "log_Apps", improved_predictors.copy(), p_threshold=0.05, verbose=True)
print("\n[Improved log(Apps) model after backward elimination]")
print(ols_log_imp_be.summary())
print("[Kept predictors - improved]:", kept_imp)

# (j) Interpret coefficients precisely (print a simple interpretation)
print("\n[Interpretation hints for log model coefficients]")
print("In the log(Apps) model, a one-unit increase in a predictor corresponds to a multiplicative change in expected Apps.")
print("For example, a coefficient b on 'log1p_Outstate' can be interpreted as: a 1% (~0.01) proportional increase in Outstate")
print("changes expected Apps by approximately b*0.01 in log-units, i.e., about 100*b*0.01 percent for small changes.")

# (k) Predictions & (l) MSE on estimation and test
def evaluate_model(model, df_est, df_test, response_col):
    y_est = df_est[response_col]
    y_test = df_test[response_col]
    pred_est = model.predict(df_est)
    pred_test = model.predict(df_test)
    if response_col == "log_Apps":
        # convert back to Apps scale for an intuitive MSE
        mse_est = mean_squared_error(np.expm1(y_est), np.expm1(pred_est))
        mse_test = mean_squared_error(np.expm1(y_test), np.expm1(pred_test))
    else:
        mse_est = mean_squared_error(y_est, pred_est)
        mse_test = mean_squared_error(y_test, pred_test)
    return mse_est, mse_test

mse_est_lin, mse_test_lin = evaluate_model(ols_be, est, test, "Apps")
mse_est_log, mse_test_log = evaluate_model(ols_log_be, est, test, "log_Apps")
mse_est_imp, mse_test_imp = evaluate_model(ols_log_imp_be, est, test, "log_Apps")

print("\n[MSE Comparison] (lower is better)")
print(f"  Linear Apps model:    Estimation MSE={mse_est_lin:,.1f}, Test MSE={mse_test_lin:,.1f}")
print(f"  Log Apps model:       Estimation MSE={mse_est_log:,.1f}, Test MSE={mse_test_log:,.1f}")
print(f"  Improved Log model:   Estimation MSE={mse_est_imp:,.1f}, Test MSE={mse_test_imp:,.1f}")

# ===========================
# Deel 3
# ===========================
print("\n===========================")
print("Deel 3: Logit model voor slagingssucces (>60%)")
print("===========================\n")

df["high_grad"] = (df["Grad_Rate"] > 60).astype(int)

# Reuse previous split (est/test) OR rebuild from df_shuffled indices
est3 = est.copy()
test3 = test.copy()

# Build engineered rates to avoid redundancy:
#   acceptance_rate = Accept/Apps  (already built earlier for df)
#   yield_rate      = Enroll/Accept
for frame in (est3, test3):
    frame["accept_rate"] = frame["Accept"] / frame["Apps"]
    frame["yield_rate"]  = frame["Enroll"] / frame["Accept"]
    # Avoid infs
    frame["accept_rate"] = frame["accept_rate"].replace([np.inf, -np.inf], np.nan)
    frame["yield_rate"]  = frame["yield_rate"].replace([np.inf, -np.inf], np.nan)

# Candidate predictors for logit
logit_candidates = [
    "C(Private)", "Top10perc", "Top25perc",
    "F_Undergrad", "P_Undergrad",
    "Outstate", "Room_Board", "Books", "Personal",
    "PhD", "Terminal", "S_F_Ratio", "perc_alumni", "Expend",
    "accept_rate", "yield_rate"
]

# Drop rows with NA in response or predictors for estimation
est3_mod = est3.dropna(subset=["high_grad"] + logit_candidates).copy()
test3_mod = test3.dropna(subset=["high_grad"] + logit_candidates).copy()

logit_full = smf.logit("high_grad ~ " + " + ".join(logit_candidates), data=est3_mod).fit(disp=False)
print("\n[Logit Full]")
print(logit_full.summary())

logit_be, kept_logit = backward_elimination_logit(est3_mod, "high_grad", logit_candidates.copy(), p_threshold=0.05, verbose=True)
print("\n[Logit Backward Elimination Result]")
print(logit_be.summary())
print("[Kept predictors - logit]:", kept_logit)

# Significant variables (p<0.05)
sig = logit_be.pvalues[logit_be.pvalues < 0.05].drop(labels=["Intercept"], errors="ignore")
print("\n[Significant predictors in final logit (p<0.05)]")
print(sig)

# Accuracy on estimation and test
def classify_probs(model, dfX, thr=0.5):
    probs = model.predict(dfX)
    return (probs >= thr).astype(int), probs

y_est3 = est3_mod["high_grad"].astype(int)
y_test3 = test3_mod["high_grad"].astype(int)

yhat_est3, phat_est3 = classify_probs(logit_be, est3_mod)
yhat_test3, phat_test3 = classify_probs(logit_be, test3_mod)

acc_est3 = accuracy_score(y_est3, yhat_est3)
acc_test3 = accuracy_score(y_test3, yhat_test3)
cm_est3 = confusion_matrix(y_est3, yhat_est3)
cm_test3 = confusion_matrix(y_test3, yhat_test3)

print(f"\n[Accuracy] Estimation={acc_est3:.3f}, Test={acc_test3:.3f}")
print("[Confusion Matrix - Estimation]")
print(cm_est3)
print("[Confusion Matrix - Test]")
print(cm_test3)

print("\nAll steps completed. Figures saved to ./figs/.")
