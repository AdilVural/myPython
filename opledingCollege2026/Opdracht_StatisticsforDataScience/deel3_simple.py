
# ============================================
# DEEL 3 (Simpel) — Logistiek model (>=60%)
# ============================================
# Run:   python deel3_simple.py
# Data:  /mnt/data/college_statistics.csv
# Pkgs:  pandas numpy scikit-learn

import numpy as np
import pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, confusion_matrix

DATA_PATH = "/mnt/data/college_statistics.csv"

# 1) Inlezen
df = pd.read_csv(DATA_PATH)
df.columns = [c.replace(".", "_") for c in df.columns]

# 2) Doelvariabele (1 als Grad_Rate>60)
df["high_grad"] = (df["Grad_Rate"] > 60).astype(int)

# 3) Eenvoudige features
df["Private_bin"] = (df["Private"]=="Yes").astype(int)
df["accept_rate"] = df["Accept"]/df["Apps"]
df["yield_rate"]  = df["Enroll"]/df["Accept"]

features = ["Private_bin", "Top10perc", "Outstate", "S_F_Ratio", "perc_alumni", "Expend", "accept_rate", "yield_rate"]
df_simple = df.dropna(subset=["high_grad"] + features).copy()

# 4) Train/Test (eerste 600 als train)
train = df_simple.iloc[:600].copy()
test  = df_simple.iloc[600:].copy()

X_tr = train[features].values
y_tr = train["high_grad"].values
X_te = test[features].values
y_te = test["high_grad"].values

# 5) Eenvoudig logistiek model
clf = LogisticRegression(max_iter=1000)
clf.fit(X_tr, y_tr)

# 6) Evaluatie (accuracy + confusion matrix)
pred_tr = clf.predict(X_tr)
pred_te = clf.predict(X_te)
acc_tr = accuracy_score(y_tr, pred_tr)
acc_te = accuracy_score(y_te, pred_te)

print("Accuracy train:", round(acc_tr, 3))
print("Accuracy test :", round(acc_te, 3))
print("\nConfusion matrix (test):")
print(confusion_matrix(y_te, pred_te))

# 7) Coefs tonen
import pandas as pd
coef_table = pd.DataFrame({"feature": ["Intercept"]+features,
                           "coef":    [clf.intercept_[0]] + list(clf.coef_[0])})
print("\nLogistic coefficients:")
print(coef_table.to_string(index=False))
