
# =====================================================
# DEEL 1 — Verkennen & Hypothesetoetsen (UITGELEGD)
# =====================================================

import os, numpy as np, pandas as pd, matplotlib.pyplot as plt
from scipy import stats

DATA_PATH = "/Users/adilvural/Documents/GitHub/myPython/opleding college 2026/Opdracht_Statistics for Data Science 2025-2026/college_statistics.csv"
FIG_DIR   = "/Users/adilvural/Documents/GitHub/myPython/opleding college 2026/Opdracht_Statistics for Data Science 2025-2026/college_statistics"
os.makedirs(FIG_DIR, exist_ok=True)

def savefig(name):
    plt.savefig(os.path.join(FIG_DIR, name), bbox_inches="tight", dpi=150)
    plt.close()

df = pd.read_csv(DATA_PATH)
df.columns = [c.replace(".", "_") for c in df.columns]
print("Vorm (rijen, kolommen):", df.shape)
print(df.head())

plt.figure()
df.boxplot(column="F_Undergrad", by="Private")
plt.title("F_Undergrad per Private")
plt.suptitle("")
savefig("01_private_box.png")

df["accept_rate"] = df["Accept"]/df["Apps"]
df["total_cost"]  = df["Outstate"]+df["Room_Board"]
r,p = stats.pearsonr(df["accept_rate"].dropna(), df["total_cost"].dropna())
print("Correlatie accept_rate vs total_cost:", r, p)

plt.figure()
plt.scatter(df["accept_rate"], df["total_cost"])
plt.title("Selectiviteit vs Kosten")
savefig("02_selectivity_cost.png")

plt.figure()
df["Room_Board"].hist(bins=30)
plt.title("Room & Board (histogram)")
savefig("03_room_board_hist.png")

elite = df["Top10perc"]>50
apps_elite, apps_non = df.loc[elite,"Apps"].dropna(), df.loc[~elite,"Apps"].dropna()
t,pv = stats.ttest_ind(apps_elite, apps_non, equal_var=False)
print("t-test Apps: elite vs non-elite:", t, pv)

valid = df[["accept_rate","Grad_Rate"]].dropna()
r2,p2 = stats.pearsonr(valid["accept_rate"], valid["Grad_Rate"])
print("Correlatie accept_rate vs Grad_Rate:", r2, p2)
