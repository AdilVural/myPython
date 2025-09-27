
# ==================================================================
# DEEL 3 — Logistisch model voor Grad_Rate>60% (UITGELEGD)
# ==================================================================

import numpy as np, pandas as pd
from sklearn.linear_model import LogisticRegression
from sklearn.metrics import accuracy_score, confusion_matrix

DATA_PATH = "/mnt/data/college_statistics.csv"

df = pd.read_csv(DATA_PATH); df.columns=[c.replace(".","_") for c in df.columns]
df["high_grad"] = (df["Grad_Rate"]>60).astype(int)
df["Private_bin"]=(df["Private"]=="Yes").astype(int)
df["accept_rate"]=df["Accept"]/df["Apps"]
df["yield_rate"]=df["Enroll"]/df["Accept"]
features=["Private_bin","Top10perc","Outstate","S_F_Ratio","perc_alumni","Expend","accept_rate","yield_rate"]
df_simple=df.dropna(subset=["high_grad"]+features)

train,test=df_simple.iloc[:600],df_simple.iloc[600:]
X_tr,y_tr=train[features],train["high_grad"]
X_te,y_te=test[features], test["high_grad"]

clf=LogisticRegression(max_iter=1000); clf.fit(X_tr,y_tr)
print("Accuracy train:", accuracy_score(y_tr,clf.predict(X_tr)))
print("Accuracy test :", accuracy_score(y_te,clf.predict(X_te)))
print("Confusion matrix (test):"); print(confusion_matrix(y_te,clf.predict(X_te)))

print(pd.DataFrame({"feature":["Intercept"]+features,"coef":[clf.intercept_[0]]+list(clf.coef_[0])}))
