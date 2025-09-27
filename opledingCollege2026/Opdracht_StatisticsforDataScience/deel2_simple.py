
# ============================================
# DEEL 2 (Simpel) — Voorspel Apps (lineair)
# ============================================
# Run:   python deel2_simple.py
# Data:  /mnt/data/college_statistics.csv
# Pkgs:  pandas numpy scikit-learn matplotlib

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

DATA_PATH = "/mnt/data/college_statistics.csv"

# 1) Inlezen
df = pd.read_csv(DATA_PATH)
df.columns = [c.replace(".", "_") for c in df.columns]

# 2) Eenvoudige features (alleen pre-application variabelen)
df["Private_bin"] = (df["Private"]=="Yes").astype(int)
features = ["Private_bin", "Top10perc", "F_Undergrad", "Outstate", "Room_Board", "Expend"]
df_simple = df.dropna(subset=["Apps"] + features).copy()

# 3) Train/Test (eerste 600 als train)
train = df_simple.iloc[:600].copy()
test  = df_simple.iloc[600:].copy()

X_tr = train[features].values
y_tr = train["Apps"].values
X_te = test[features].values
y_te = test["Apps"].values

# 4) Eenvoudig lineair model
m = LinearRegression()
m.fit(X_tr, y_tr)

# 5) Evaluatie
pred_tr = m.predict(X_tr)
pred_te = m.predict(X_te)
mse_tr = mean_squared_error(y_tr, pred_tr)
mse_te = mean_squared_error(y_te, pred_te)
print("MSE train:", round(mse_tr, 1))
print("MSE test :", round(mse_te, 1))

# 6) (Optioneel) Log-transform van doel
train["log_Apps"] = np.log1p(train["Apps"])
test["log_Apps"]  = np.log1p(test["Apps"])

m2 = LinearRegression()
m2.fit(train[features].values, train["log_Apps"].values)

pred_tr2 = m2.predict(train[features].values)
pred_te2 = m2.predict(test[features].values)

# vergelijk op Apps-schaal
mse_tr2 = mean_squared_error(train["Apps"].values, np.expm1(pred_tr2))
mse_te2 = mean_squared_error(test["Apps"].values,  np.expm1(pred_te2))

print("MSE train (log-model, teruggeschaald):", round(mse_tr2, 1))
print("MSE test  (log-model, teruggeschaald):", round(mse_te2, 1))

# 7) Coefs tonen
coef_table = pd.DataFrame({"feature": ["Intercept"]+features,
                           "coef":    [m.intercept_] + list(m.coef_)})
print("\nCoëfficiënten (simpel model):")
print(coef_table.to_string(index=False))
