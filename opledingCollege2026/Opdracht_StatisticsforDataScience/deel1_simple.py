
# ==================================
# DEEL 1 (Simpel) — Verkennen & Tests
# ==================================
# Run:   python deel1_simple.py
# Data:  /mnt/data/college_statistics.csv
# Pkgs:  pandas numpy scipy matplotlib

import os
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy import stats

DATA_PATH = "/mnt/data/college_statistics.csv"
FIG_DIR = "/mnt/data/figs_deel1_simple"
os.makedirs(FIG_DIR, exist_ok=True)

def savefig(name):
    plt.savefig(os.path.join(FIG_DIR, name), bbox_inches="tight", dpi=150)
    plt.close()

# 1) Inlezen
df = pd.read_csv(DATA_PATH)
df.columns = [c.replace(".", "_") for c in df.columns]

print("Vorm:", df.shape)
print(df.head())

# 2) Private vs Public: grootte (F_Undergrad)
plt.figure()
df.boxplot(column="F_Undergrad", by="Private")
plt.title("F_Undergrad per Private")
plt.suptitle("")
plt.xlabel("Private (Yes/No)")
plt.ylabel("Full-time undergrads")
savefig("deel1_private_box.png")

# 3) Selectiviteit vs Kosten (correlatie)
df["accept_rate"] = df["Accept"]/df["Apps"]
df["total_cost"]  = df["Outstate"] + df["Room_Board"]
r, p = stats.pearsonr(df["accept_rate"].dropna(), df["total_cost"].dropna())
print(f"Correlatie accept_rate vs total_cost: r={r:.3f}, p={p:.4g}")

plt.figure()
plt.scatter(df["accept_rate"], df["total_cost"])
plt.xlabel("accept_rate")
plt.ylabel("total_cost")
plt.title("Selectiviteit vs Kosten")
savefig("deel1_selectivity_cost.png")

# 4) Verdeling Room & Board (histogram)
plt.figure()
df["Room_Board"].hist(bins=30)
plt.title("Room & Board (histogram)")
plt.xlabel("Room_Board")
plt.ylabel("Aantal")
savefig("deel1_room_board_hist.png")

# 5) Hypothesevoorbeelden
# (a) Elite (Top10perc>50) vs non-elite — t-test Apps
elite = df["Top10perc"] > 50
apps_elite = df.loc[elite, "Apps"].dropna()
apps_non   = df.loc[~elite, "Apps"].dropna()
tstat, pval = stats.ttest_ind(apps_elite, apps_non, equal_var=False)
print(f"t-test Apps: elite vs non-elite: t={tstat:.3f}, p={pval:.4g}")

# (b) accept_rate vs Grad_Rate — Pearson
valid = df[["accept_rate", "Grad_Rate"]].dropna()
r2, p2 = stats.pearsonr(valid["accept_rate"], valid["Grad_Rate"])
print(f"Correlatie accept_rate vs Grad_Rate: r={r2:.3f}, p={p2:.4g}")

print("Klaar. Figuren in:", FIG_DIR)
