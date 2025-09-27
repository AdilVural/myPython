
# ===============================================================
# DEEL 2 — Lineair model om Apps te voorspellen (UITGELEGD)
# ===============================================================

import numpy as np, pandas as pd
from sklearn.linear_model import LinearRegression
from sklearn.metrics import mean_squared_error

DATA_PATH = "/mnt/data/college_statistics.csv"

df = pd.read_csv(DATA_PATH)
df.columns = [c.replace(".", "_") for c in df.columns]

df["Private_bin"] = (df["Private"]=="Yes").astype(int)
features = ["Private_bin","Top10perc","F_Undergrad","Outstate","Room_Board","Expend"]
df_simple = df.dropna(subset=["Apps"]+features)

train,test = df_simple.iloc[:600], df_simple.iloc[600:]
X_tr,y_tr = train[features].values, train["Apps"].values
X_te,y_te = test[features].values,  test["Apps"].values

m = LinearRegression(); m.fit(X_tr,y_tr)
print("MSE train:", mean_squared_error(y_tr,m.predict(X_tr)))
print("MSE test :", mean_squared_error(y_te,m.predict(X_te)))

train["log_Apps"] = np.log1p(train["Apps"]); test["log_Apps"]=np.log1p(test["Apps"])
m2 = LinearRegression(); m2.fit(train[features], train["log_Apps"])
from numpy import expm1
print("MSE train (log-model):", mean_squared_error(train["Apps"], expm1(m2.predict(train[features]))))
print("MSE test  (log-model):", mean_squared_error(test["Apps"], expm1(m2.predict(test[features]))))

import pandas as pd
print(pd.DataFrame({"feature":["Intercept"]+features,"coef":[m.intercept_]+list(m.coef_)}))
