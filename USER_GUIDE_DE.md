# Timerevo — Benutzerhandbuch Zeiterfassung

## Installation Timerevo

1. Entpacken Sie das Release-Archiv in einen geeigneten Ordner
   (z. B. `timerevo-windows-<Version>.zip` von [GitHub Releases](https://github.com/knr83/timerevo/releases);
   z. B. `C:\Program Files\timerevo` oder `C:\Users\<Ihr_Name>\timerevo`).

2. Starten Sie timerevo.exe.

3. Beim ersten Start erstellt die Anwendung die Datenbank im Windows-Profil **Roaming**
   (üblicherweise: `%APPDATA%\Timerevo\Timerevo\`; die Datenbankdatei heißt `timerevo.sqlite`).

Voraussetzungen: Windows 10/11 (64-bit)

Dieses Handbuch bezieht sich auf die **Windows**-Desktopversion. Unter Linux und macOS unterscheiden sich Archivnamen und Datenbankpfade; siehe die **README.md** im Repository (Abschnitt *Data storage*).

## Start
Doppelklicken Sie auf `timerevo.exe`.

---

## Terminal (Startbildschirm)

1. Wählen Sie einen Mitarbeiter aus der Liste.
2. Geben Sie die PIN ein, falls erforderlich (Mitarbeiter mit aktivierter PIN).
3. Beim ersten Mal, wenn es für einen Mitarbeiter nötig ist — **Bestätigung der Richtlinie** (Datenschutzerklärung und Nutzungsbedingungen; Häkchen setzen zum Fortfahren). Wird **pro Mitarbeiter** gespeichert (nach der PIN), nicht nur beim ersten App-Start.
4. Tippen Sie auf **KOMMEN**, um eine Schicht zu beginnen, oder **GEHEN**, um sie zu beenden.
5. **Mein Arbeitskalender** — Kalender mit Schichten und Abwesenheiten; hier können Sie eine Abwesenheitsanfrage stellen.
6. **Zeitbericht (PDF)** — PDF-Export nach Zeitraum (Heute / Woche / Monat / Benutzerdefiniert).
7. Liste der heutigen Schichten; „Noch N anzeigen“ — alle aufklappen.
8. Wenn eine Schicht nach Ende der Arbeitszeit noch offen ist — Block zum Schließen mit Datum- und Zeitauswahl.
9. Die Schaltfläche **Verwaltung** (in der App-Leiste) öffnet das Admin-Panel.

---

## Verwaltung

Geben Sie die Admin-PIN zum Entsperren ein. Zum Abmelden **Zurück** drücken — die Verwaltung sperrt automatisch.

> Beim ersten Zugang verwenden Sie die Standard-PIN: `0000`.
> Aus Sicherheitsgründen ändern Sie diese nach dem Login unter **Einstellungen → PIN ändern**.

Menü **Hilfe**: Datenschutzerklärung, Nutzungsbedingungen, Über die App.

### Mitarbeiter
- **Hinzufügen** (➕): neuen Mitarbeiter anlegen.
- Mitarbeiter auswählen, um die Karte anzuzeigen oder zu bearbeiten.
- Pflichtfelder: Code, Vorname, Nachname.
- Optional: Einstellungsdatum, Austrittsdatum, Urlaubstage pro Jahr, Rolle, Beschäftigungsart, Abteilung, Position, Kontaktdaten.
- **Status**: aktiv, inaktiv oder archiviert. Im Terminal erscheinen nur **aktive** Mitarbeiter (innerhalb Einstellungs- und Austrittsdatum).
- **PIN aktivieren**: PIN für Stempeln verlangen; PIN pro Mitarbeiter setzen oder zurücksetzen.
- **NFC aktivieren**: alternativer Zugang per NFC-Token.
- **Planzettel** zuweisen (geplante Wochenstunden ergeben sich aus dem Planzettel, kein separates Feld in der Karte).
- **Mitarbeiterdaten (PDF) exportieren** — in der Karte beim Bearbeiten eines vorhandenen Mitarbeiters.

### Pläne
- Planzettel erstellen und verwalten (z. B. „Standardwoche“).
- Planzettel mit ➕ hinzufügen; Menü ⋮ — Umbenennen, Aktivieren/Deaktivieren.
- Arbeitszeiten pro Wochentag festlegen (Mo–So).
- Beginn- und Endzeit wählen; Schalter „Nachtschicht“ für Schichten über Mitternacht.
- Planzettel Mitarbeitern in der Mitarbeiterkarte zuweisen.
- **PDF** (Symbol in der Leiste): Export einer Übersicht aller Mitarbeiter und Wochenplanzettel.

### Journal
- Ansichten: **Tabelle**, **Zeitleiste**, **Nach Intervallen**.
- **Zeitraumleiste**: Bereich **Tag** / **Woche** / **Monat** / **Intervall**; **Heute** und Vor/Zurück; bei **Intervall** Datumsbereich wählen.
- **Tabellen**ansicht: Spalten Mitarbeiter, Beginn, Ende, Dauer, Status. **Status**-Filter: Alle / Offen / **Nicht geschlossen** / Geschlossen; Mitarbeiter; **Suchen** (Name oder Notiz).
- Zeile bearbeiten: Beginn/Ende, Notiz, Grund der Änderung (Pflichtfeld), „Jetzt beenden“, „Ende zurücksetzen“.

### Abwesenheiten
- Filter: Mitarbeiter, Status (Alle / Ausstehend / Genehmigt / Abgelehnt), **Zeitraum** (dieselbe Zeitraumleiste: Bereich, Heute, Navigation, optional eigener Bereich).
- Tabelle: Mitarbeiter, Art, Von/Bis, Status, Genehmigt von, Wann.
- Arten: Urlaub, Krankheit, Unbezahlter Urlaub, Elternzeit, Bildungsurlaub, Sonstige.
- **Abwesenheit hinzufügen** — Schaltfläche zum Anlegen.
- Für ausstehende: Bearbeiten, Löschen, Genehmigen, Ablehnen (bei Ablehnung — Grund erforderlich).

### Berichte
- Übersicht nach Mitarbeiter und Zeitraum anzeigen. In die Summen gehen nur **geschlossene** Schichten ein.
- **Zeitraumleiste** (Tag / Woche / Monat / Intervall, Heute, Navigation).
- PDF-Export: gesamt oder pro ausgewähltem Mitarbeiter aus dem Detailbereich.

### Einstellungen
- **Sprache**: Systemstandard, Deutsch, Russisch oder Englisch.
- **Design**: System, Hell, Dunkel, Hoher Kontrast (hell), Hoher Kontrast (dunkel).
- **Anwesenheitsmodus**: **Flexibel** oder **Fest**; im **festen** Modus **Toleranz (Minuten)** für die Bewertung des Schichtendes.
- **Arbeitszeit**: Beginn und Ende für das Terminal (Einschränkungen beim Stempeln).
- **Startdatum der Erfassung (tracking start)**: optionales Kalenderdatum; Berichte und Auswertungen **berücksichtigen keine** Daten vor diesem Datum (wenn gesetzt). Leeren Sie das Datum, um wieder die gesamte Historie zu nutzen.
- **PIN ändern** — Admin-PIN ändern.
- **Diagnosedaten exportieren** — Speicherung von Diagnosedaten in eine Datei (für den Support).
- **„Sicherung erstellen“** — speichert die Datenbank (timerevo.sqlite) im gewählten Ordner.
- **„Aus Sicherung wiederherstellen“** — .sqlite-Datei wählen und bestätigen.

---

## Datenspeicherung (für Administratoren)

Die App speichert Daten in `timerevo.sqlite` im Anwendungs-Support-Verzeichnis (Flutter). Während die App läuft, können daneben `timerevo.sqlite-wal` und `timerevo.sqlite-shm` erscheinen.

**Datenbankpfad (Windows):**
- Ordner: `%APPDATA%\Timerevo\Timerevo\` (**Roaming**-Profil, nicht `Local`)
- Datei: `timerevo.sqlite`

Beispielpfad: `C:\Users\<Benutzer>\AppData\Roaming\Timerevo\Timerevo\timerevo.sqlite`

**Linux / macOS:** Pfade unterscheiden sich (Anwendungs-ID / Bundle). Siehe **README.md** im Repository (*Data storage*).

**Vollständige Löschung der Daten (Windows):**
1. Anwendung schließen.
2. Ordner `%APPDATA%\Timerevo\Timerevo\` löschen (oder den übergeordneten Ordner `Timerevo` unter Roaming, um alle App-Daten dieses Produkts zu entfernen).
