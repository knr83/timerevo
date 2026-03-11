# Timerevo — Benutzerhandbuch Zeiterfassung

## Installation Timerevo

1. Entpacken Sie das Archiv timerevo-*.zip in einen geeigneten Ordner
   (z. B. C:\Program Files\timerevo oder C:\Users\<Ihr_Name>\timerevo).

2. Starten Sie timerevo.exe.

3. Beim ersten Start erstellt die Anwendung die Datenbank im Anwendungsdatenordner
   (üblicherweise: %LOCALAPPDATA%\timerevo\ oder vergleichbar).

Voraussetzungen: Windows 10/11 (64-bit)

## Start
Doppelklicken Sie auf `timerevo.exe`.

---

## Terminal (Startbildschirm)

1. Wählen Sie einen Mitarbeiter aus der Liste.
2. Geben Sie die PIN ein, falls erforderlich (Mitarbeiter mit aktivierter PIN).
3. Beim ersten Zugang — **Bestätigung der Richtlinie** (Datenschutzerklärung und Nutzungsbedingungen; Häkchen setzen zum Fortfahren).
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
- Optional: Einstellungsdatum, Rolle, Beschäftigungsart, Wochenstunden, Abteilung, Position, Kontaktdaten.
- **PIN aktivieren**: PIN für Stempeln verlangen; PIN pro Mitarbeiter setzen oder zurücksetzen.
- **NFC aktivieren**: alternativer Zugang per NFC-Token.
- **Planzettel** zuweisen.
- Aktiv/Inaktiv markieren — Anzeige im Terminal ein- oder ausblenden.

### Pläne
- Planzettel erstellen und verwalten (z. B. „Standardwoche“).
- Planzettel mit ➕ hinzufügen; Menü ⋮ — Umbenennen, Aktivieren/Deaktivieren.
- Arbeitszeiten pro Wochentag festlegen (Mo–So).
- Beginn- und Endzeit wählen; Schalter „Nachtschicht“ für Schichten über Mitternacht.
- Planzettel Mitarbeitern in der Mitarbeiterkarte zuweisen.

### Journal
- Arbeitszeiten in einer Tabelle durchsuchen (Mitarbeiter, Beginn, Ende, Dauer, Status).
- Filter: Zeitraum (Von/Bis), Voreinstellungen (Heute, Woche, Monat, Letzter Monat), **Status** (Alle / Offen / Geschlossen), Mitarbeiter, **Suchen** (Name oder Notiz).
- Datum-Chips zum Setzen oder Löschen der Filter nutzen.
- Zeile bearbeiten: Beginn/Ende, Notiz, Grund der Änderung (Pflichtfeld), „Jetzt beenden“, „Ende zurücksetzen“.

### Abwesenheiten
- Filter: Mitarbeiter, Status (Alle / Ausstehend / Genehmigt / Abgelehnt), Zeitraum (Von/Bis).
- Tabelle: Mitarbeiter, Art, Von/Bis, Status, Genehmigt von, Wann.
- Arten: Urlaub, Krankheit, Unbezahlter Urlaub, Elternzeit, Bildungsurlaub, Sonstige.
- **Abwesenheit hinzufügen** — Schaltfläche zum Anlegen.
- Für ausstehende: Bearbeiten, Löschen, Genehmigen, Ablehnen (bei Ablehnung — Grund erforderlich).

### Berichte
- Übersicht nach Mitarbeiter und Zeitraum anzeigen. In die Summen gehen nur **geschlossene** Schichten ein.
- Filter nach Datumsbereich (Chips Von/Bis).
- PDF-Export: gesamt oder pro ausgewähltem Mitarbeiter aus dem Detailbereich.

### Einstellungen
- **Sprache**: Systemstandard, Deutsch, Russisch oder Englisch.
- **Design**: System, Hell, Dunkel, Hoher Kontrast (hell), Hoher Kontrast (dunkel).
- **Arbeitszeit**: Beginn und Ende für das Terminal (Einschränkungen beim Stempeln).
- **PIN ändern** — Admin-PIN ändern.
- **Diagnosedaten exportieren** — Speicherung von Diagnosedaten in eine Datei (für den Support).
- **„Sicherung erstellen“** — speichert die Datenbank (timerevo.sqlite) im gewählten Ordner.
- **„Aus Sicherung wiederherstellen“** — .sqlite-Datei wählen und bestätigen.

---

## Datenspeicherung (für Administratoren)

**Datenbankpfad:**
- Ordner: `%LOCALAPPDATA%\timerevo\`
- Datei: `timerevo.sqlite`

**Vollständige Löschung der Daten:**
1. Anwendung schließen.
2. Ordner `%LOCALAPPDATA%\timerevo\` löschen (z. B. `C:\Users\<Benutzer>\AppData\Local\timerevo`).
