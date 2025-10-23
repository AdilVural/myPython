# --- 1. Importeer Bibliotheken ---
import pandas as pd
import numpy as np
import os # Nieuwe import voor padmanipulatie
print("Stap 1: Bibliotheken geïmporteerd.")
# --- 2. Laad de Dataset (Aangepast en Robuuster) ---
# Detecteer de huidige werkmap van het script
current_directory = os.getcwd()
print(f"\nDe huidige werkmap is: {current_directory}")
/Users/adilvural/Documents/GitHub/myPython/Assignment___export/college_statistics.csv

file_name = 'college_statistics.csv'
file_path = os.path.join(current_directory, file_name) # Bouw een veilig pad naar het bestand
# Definieer de kolomnamen handmatig
# Deze moeten exact overeenkomen met de volgorde van de kolommen in je CSV-bestand.
# Gebaseerd op de gegeven data string zijn dit de kolomnamen:
column_names = ['University', 'Private', 'Apps', 'Accept', 'Enroll', 'Top10perc', 'Top25perc', 'F.Undergrad', 'P.Undergrad', 'Outstate', 'Room.Board', 'Books', 'Personal', 'PhD', 'Terminal', 'S.F.Ratio', 'perc.alumni', 'Expend', 'Grad.Rate']
try:
    # Controleer of het bestand daadwerkelijk bestaat op het gedetecteerde pad
    if not os.path.exists(file_path):
        raise FileNotFoundError(f"Bestand '{file_name}' niet gevonden op pad: {file_path}")
    # Laad het CSV-bestand
    # Belangrijk: gebruik header=None omdat de eerste rij van het CSV-bestand GEEN headers zijn, maar gewoon data.
    # Gebruik names=column_names om onze handmatig gedefinieerde headers toe te wijzen.
    df = pd.read_csv(file_path, names=column_names, header=None)
    # Zet de 'University' kolom als de index
    df = df.set_index('University')
    print(f"Stap 2: Dataset '{file_name}' succesvol geladen vanaf: {file_path}")
    print("De eerste 5 rijen van de dataset:")
    print(df.head())
    print(f"\nKolomnamen na laden: {df.columns.tolist()}") # Controleer de geladen kolomnamen
    print(f"Vorm van de DataFrame (rijen, kolommen): {df.shape}")
    print("\nDataset informatie:")
    df.info()
except FileNotFoundError as e:
    print(f"Fout: {e}")
    print("Mogelijke oplossingen:")
    print(f"1. Plaats '{file_name}' in de map '{current_directory}'.")
    print("2. Controleer of de bestandsnaam correct gespeld is (inclusief hoofdletters/kleine letters en extensie).")
    print("3. Als je een IDE (zoals VS Code of PyCharm) gebruikt, controleer dan de 'working directory' instellingen.")
    # Exit om te voorkomen dat de rest van het (niet-bestaande) script wordt uitgevoerd
    exit()
except pd.errors.EmptyDataError:
    print(f"Fout: Het bestand '{file_name}' is leeg. Kan geen data inlezen.")
    exit()
except Exception as e:
    print(f"Een onverwachte fout opgetreden bij het laden van het CSV-bestand: {e}")
    exit()
# Op dit punt is 'df' je geladen DataFrame. Je kunt nu verder gaan met andere stappen.