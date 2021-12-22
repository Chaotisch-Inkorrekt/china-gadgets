# Microsites für die China Gadgets aus Methodisch Inkorrekt

Hier findet ihr eine Sammlung der China Gadgets aus den verschiedenen Episoden des Podcasts Methodisch Inkorrekt als kleine HTML-Seiten mit Bildern und Links aus den Shownotes und anderen Quellen (siehe unten).

## Gadgets

| Gadget                            | Name     | Bildquellen                  |
|-----------------------------------|----------|------------------------------|
{{gadgets}}

## Datenquellen

China Gadgets: <https://github.com/Minkorrekt-Fakts/minkorrekt_chinagadgets>

Episoden: <https://minkorrekt.podigee.io/feed/mp3> & <https://github.com/Fenrikur/minkorrekt-topics>

## Datenformat

Die Daten aus welchen die HTML-Seiten in `/html` und diese `README.md` erzeugt werden sind im YAML-Format in der Datei [gadgets.local.yaml](./data/gadgets.local.yaml) abgelegt und können dort mit beliebigen Texteditoren bearbeitet werden.
Direkte Änderungen an den generierten Dateien werden beim nächsten Generierungslauf überschrieben, weshalb Änderungen nur an der YAML bzw. den Templates [README.tpl.md](./bin/README.tpl.md) und [gadget-000.tpl.html](./bin/gadget-000.tpl.html) vorgenommen werden sollten. Fotos zu den Gadgets sind unter [./html/img](./html/img) abgelegt.

Innerhalb dieser Datei existiert jedes Gadget als ein Array-Element mit der folgenden Struktur:

```yaml
- gadget: "4" # ID des Gadgets; in der Regel identisch zur Nummer der Folge, bei mehreren Gadgets pro Folge im Format "Folgennummer.Index", also z.B. "4.1", "4.2" etc.
  episode: "4" # Nummer der Podcastfolge, in welcher das Gadget vorgestellt wurde.
  date: "03.07.2013" # Datum der Podcastfolge
  title: "PET-Bewässerung" # Titel des Gadgets (manchmal auch Kurzbeschreibung; sollte nur wenige Worte umfassen)
  images: # Liste mit 0 oder mehr Bildern (WICHTIG: Bilder dürfen nur mit Genehmigung UND Angabe der Quelle in den sources hinzugefügt werden!)
    - title: "" # Titel des Bildes (insb. für barrierefreiheien Zugriff mit Screen Readern wichtig)
      url: "./img/gadget-004-1.jpg" # URL des einzubettenden Bildes (könnte auch Remote liegen, ist aber vmtl. nicht zu empfehlen); relativ zum Verzeichnis /html.
    - title: ""
      url: "./img/gadget-004-2.jpg"
  sources: # Liste der Bildquellen von welchen die o.g. Bilder stammen
    - title: "Minkorrekt UG" # Name der Bildquelle (je nach Rücksprache/Lizenz)
      url: "https://get.google.com/albumarchive/107341743493109591753/album/AF1QipOFHLdJGRd-SuBmG1JxGm0DIJf3Q43jrNrBWJgR?source=pwa&authKey=CPPL1prh7MSrQQ" # URL auf welche die Bildquelle verlinkt
  links: # Liste weiterführender Links zum Gadget
    - title: "Google Photos" # Text mit dem der Link dargestellt wird
      url: "https://get.google.com/albumarchive/107341743493109591753/album/AF1QipOFHLdJGRd-SuBmG1JxGm0DIJf3Q43jrNrBWJgR?source=pwa&authKey=CPPL1prh7MSrQQ" # URL auf welche der Link verweist

```
