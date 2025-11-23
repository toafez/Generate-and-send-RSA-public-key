# Öffentlichen RSA-Schlüssel generieren und senden.

## Worum geht es?
Mithilfe des hier vorgestellten Skripts soll die Einrichtung einer SSH-Public-Key-Authentifizierung zwischen einem lokalen Linux-basierten Betriebssystem und einem Linux-basierten Remote-System über die Kommandozeile erleichtert werden.

## Einleitung
Secure Shell, abgekürzt SSH, ist ein Netzwerkprotokoll zum Aufbau verschlüsselter Verbindungen zwischen Geräten im lokalen Netzwerk oder über das Internet. Bei der SSH-Public-Key-Authentifizierung wird mit Hilfe eines Schlüsselpaares, bestehend aus einem privaten und einem öffentlichen Schlüssel, eine passwortfreie Anmeldung zu einem Remote-System aufgebaut, die bei Bedarf durch die Eingabe einer zusätzlichen Passphrase weiter abgesichert werden kann. Die Verwendung eines solchen Schlüsselpaares ist daher wesentlich schwieriger zu kompromittieren als die Eingabe eines Passwortes.

#### _Hinweis: Texte in Großbuchstaben innerhalb eckiger Klammern dienen als Platzhalter und müssen durch eigene Angaben ersetzt werden, können aber an einigen Stellen auch nur der Information dienen. Es ist zu beachten, dass die eckigen Klammern Teil des Platzhalters sind und beim Ersetzen durch eigene Angaben ebenfalls entfernt werden müssen._

## So funktioniert das Skript genau

- **Verzeichnisrechte ermitteln und anzeigen**  
Zunächst werden die aktuell für das Home- und das Benutzer-Home-Verzeichnis gesetzten Berechtigungen zur reinen Information ermittelt und angezeigt. 

- **SSH-Verzeichnis erstellen bzw. überprüfen**  
Danach wird geprüft, ob im lokalen Benutzer-Home-Verzeichnis `~/[BENUTZERNAME]` bereits ein Unterverzeichnis mit dem Namen`.ssh` vorhanden ist. Besteht das Verzeichnis bereits, werden lediglich die Verzeichnisrechte kontrolliert und bei Bedarf angepasst. Andernfalls wird das Verzeichnis `~/[BENUTZERNAME]/.ssh` neu erstellt und die entsprechenden Verzeichnisrechte gesetzt.

- **RSA-Schlüsseldateien erstellen bzw. überprüfen**  
Als Nächstes wird geprüft, ob sich im Verzeichnis `~/[BENUTZERNAME]/.ssh` bereits ein RSA-Schlüsselpaar mit dem Standarddateinamen `id_rsa` oder einem selbstgewählten Dateinamen, der beim Aufruf des Skripts angegeben wurde, befindet. Besteht das RSA-Schlüsselpaar bereits, werden lediglich die Dateirechte kontrolliert und bei Bedarf angepasst. Andernfalls wird das RSA-Schlüsselpaar neu erstellt und die entsprechenden Dateirechte gesetzt.

- **authorized_keys Datei erstellen bzw. überprüfen**  
Anschließend wird geprüft, ob sich im Verzeichnis `~/[BENUTZERNAME]/.ssh` bereits eine Datei namens `authorized_keys` befindet und ob darin der eigene öffentliche RSA-Schlüssel hinterlegt ist. Besteht die Datei bereits und ist der öffentliche RSA-Schlüssel hinterlegt, werden lediglich die Dateirechte kontrolliert und bei Bedarf angepasst. Andernfalls wird der öffentliche RSA-Schlüssel hinzugefügt. Fehlt die Datei `authorized_keys` im Verzeichnis `~/[BENUTZERNAME]/.ssh`, wird sie zunächst neu erstellt und die entsprechenden Dateirechte werden gesetzt.

- **config Datei erstellen bzw. überprüfen**  
Es wird außerdem geprüft, ob sich im Verzeichnis `~/[BENUTZERNAME]/.ssh` bereits eine Datei namens config befindet und ob darin die Zugangsdaten zum angegebenen Hostnamen des Remote-Systems hinterlegt sind. Besteht die Datei bereits und sind die Zugangsdaten hinterlegt, werden lediglich die Dateirechte kontrolliert und bei Bedarf angepasst. Andernfalls werden die Zugangsdaten hinzugefügt. Fehlt die Datei `config`, wird sie zunächst neu erstellt und die entsprechenden Dateirechte werden gesetzt.

- **SSH-Verbindung zum Remote-System aufbauen** 
Nun wird eine SSH-Verbindung zum ausgewählten Remote-System aufgebaut, um den öffentlichen RSA-Schlüssel zu übertragen. 

- **Remote SSH-Verzeichnis erstellen bzw. überprüfen**  
Nach dem Aufbau der Verbindung wird zunächst geprüft, ob im Benutzer-Home-Verzeichnis `~/[REMOTE-BENUTZERNAME]` bereits ein Unterverzeichnis namens `.ssh` vorhanden ist. Besteht das Verzeichnis bereits, werden lediglich die Verzeichnisrechte kontrolliert und bei Bedarf angepasst. Andernfalls wird das Verzeichnis `~/[REMOTE-BENUTZERNAME]/.ssh` neu erstellt und die entsprechenden Verzeichnisrechte gesetzt.

- **Remote authorized_keys Datei erstellen bzw. überprüfen**  
Anschließend wird geprüft, ob sich im Verzeichnis `~/[REMOTE-BENUTZERNAME]/.ssh` bereits eine Datei namens `authorized_keys` befindet. Besteht die Datei bereits, wird außerdem geprüft, ob der zuvor erzeugte öffentliche RSA-Schlüssel bereits darin hinterlegt wurde. Falls nicht, wird der öffentliche RSA-Schlüssel in der Datei gespeichert. Abschließend werden die Dateirechte kontrolliert und bei Bedarf angepasst. Fehlt die Datei `authorized_keys` im Verzeichnis `~/[REMOTE-BENUTZERNAME]/.ssh`, wird sie zunächst neu erstellt und die entsprechenden Dateirechte werden gesetzt.

- **SSH-Verbindung zum Remote-System trennen**  
Zum Schluss wird die SSH-Verbindung getrennt. Wenn alle Schritte fehlerfrei ausgeführt wurden, sollte ab sofort eine passwortlose SSH-Verbindung per Public-Key-Authentifizierung möglich sein. Um dies zu testen, wird erneut eine SSH-Verbindung zum Remote-System aufgebaut. Diesmal sollte eine Anmeldung ohne weitere Eingaben möglich sein.


  - Verbindung unter Verwendung des Benutzernamens, der Adresse und des Ports herstellen:
	
      ssh [REMOTE-USERNAME]@[REMOTE-ADDRESS] -p [REMOTE-PORT] 

  - Verbindung unter Verwendung des Hostnamens, dessen Zugangsdaten in der config Datei hinterlegt wurden:
	
      ssh [REMOTE-HOSTNAME]

## Installationshinweise
Mit Hilfe des Kommandozeilenprogramms `curl` kann die Shell-Skript-Datei **generate-and-send-rsa-public-key.sh** einfach über ein Terminalprogramm deiner Wahl heruntergeladen werden. Als Speicherort bietet sich das eigene Benutzer-Home-Verzeichnis an, es kann jedoch auch jedes andere Verzeichnis verwendet werden. Wechsle in das von dir gewählte Verzeichnis. Führe dann den folgenden Befehl aus. Damit wird die Skriptdatei in das ausgewählte Verzeichnis heruntergeladen.

**Download der Shell-Skript-Datei generate-and-send-rsa-public-key.sh**

	curl -L -O https://raw.githubusercontent.com/toafez/Generate-and-send-RSA-public-key/refs/heads/main/scripts/generate-and-send-rsa-public-key.sh
	

Führe anschließend im selben Verzeichnis den folgenden Befehl aus, um der Shell-Skript-Datei **generate-and-send-rsa-public-key.sh** Ausführungsrechte zu erteilen.

	chmod +x generate-and-send-rsa-public-key.sh

## Skript ausführen
Die Shell-Skript-Datei `generate-and-send-rsa-public-key.sh` sollte immer mit dem Benutzer ausgeführt werden, mit dem man sich am System angemeldet hat und der über die nötigen Berechtigungen verfügt, um eine SSH-Verbindung zu einem Remote-System aufzubauen. 

Aus Sicherheitsgründen sollte die Shell-Skript-Datei möglichst nicht mit Root-Berechtigungen (d. h. mit vorangestelltem sudo-Befehl) oder als Root selbst ausgeführt werden, auch wenn dies möglich ist. 

Aus Sicherheitsgründen sollte man sich außerdem möglichst nicht als Systembenutzer `root` über eine SSH-Verbindung mit einem Remote-System verbinden. Die meisten Systeme lassen dies ohne Anpassung der SSH-Konfiguration ohnehin nicht zu.

Der Aufruf selbst erfolgt am besten, indem man den absoluten Pfad, d.h. den Verzeichnispfad, in dem sich die Shell-Skript-Datei `generate-and-send-rsa-public-key.sh` befindet, voranstellt, wobei auch der relative Pfad genügt, wenn man sich selbst im selben Verzeichnis wie das Shell-Skript befindet. 

Entweder so:

	bash /[ABSOLUTER-PFAD]/generate-and-send-rsa-public-key.sh "REMOTE-USERNAME" "REMOTE-ADDRESS" "REMOTE-HOSTNAME" "REMOTE-PORT" "KEYFILE-NAME"	

Oder auch so:

	. ./generate-and-send-rsa-public-key.sh "REMOTE-USERNAME" "REMOTE-ADDRESS" "REMOTE-HOSTNAME" "REMOTE-PORT" "KEYFILE-NAME"	

## Erläuterung der einzelnen Optionsschalter	
```
REMOTE-USERNAME       : Dies muss durch den Benutzernamen ersetzt werden,
                        mit dem du dich am Remote-System anmeldest.

REMOTE-ADDRESS        : Diese muss durch die IP-Adresse oder URL ersetzt werden,
                        über die der Remote-System erreichbar ist.

REMOTE-HOSTNAME       : Dies kann durch den Hostnamen bzw. die Bezeichnung des
                        Remote-Systems ersetzt werden,wie z.B."Fileserver" oder
                        "Backupserver". Wenn kein Hostname angegeben ist, d.h.
                        wenn kein Wert innerhalb der Anführungszeichen angegeben
                        wurde, wird kein Eintrag in die Konfigurationsdatei
                        ~/.ssh/config vorgenommen.

REMOTE-PORT           : Dies kann durch den Port ersetzt werden, über den der
                        Remote-System erreichbar ist. Wenn kein Port
                        angegeben ist, d.h. wenn kein Wert innerhalb der
                        Anführungszeichen angegeben wurde, wird der Standardport
                        "22" verwendet.

KEYFILE-NAME          : Dies kann durch den Namen der Datei ersetzt werden, die
                        für das RSA-Schlüsselpaar verwendet werden soll. Wenn
                        kein Dateiname angegeben ist, d.h. wenn kein Wert
                        innerhalb der Anführungszeichen angegeben wurde, wird
                        der Standarddateiname "id_rsa" verwendet.
```

## Beispielausgabe
Nachfolgend ist eine beispielhafte Ausgabe zu sehen, die entsteht, nachdem das Skript ausgeführt wurde. 
```
toafez@Linux-Mint:~$ . ./generate-and-send-rsa-public-key.sh "tommes" "172.16.1.12" "Ubuntu-Server" "" ""

Display the permissions for the home directory and the user home directory
 - The permissions for the home directory [ /home ] are set to 700 (drwx------)
 - The permissions for the user home directory [ /home/toafez ] are set to 700 (drwx------)

Create a new SSH directory structure or check an existing one in the user's local home directory [ /home/toafez ].
 - Create the subdirectory [ /.ssh ] in your local home directory [ /home/toafez ].
 - The permissions for the subdirectory [ /home/toafez/.ssh ] have been changed to 0700 (rwx------).

Create new RSA key pairs or check existing ones in the local [ /home/toafez/.ssh ] subdirectory.
 - The private RSA key, named [ id_rsa ], has been created.
 - The public RSA key, named [ id_rsa.pub ], has been created.
 - The permissions for the private RSA key [ id_rsa ] has been verified and is correct.
 - The permissions for the public RSA key [ id_rsa.pub ] have been changed to 0600 (rw-------).

Create a new file or check an existing file named [ authorized_keys ] in the local [ /home/toafez/.ssh ] subdirectory.
 - The [ authorized_keys ] file has been created.

Add your own public RSA key [ id_rsa.pub ] to the local [ authorized_keys ] file.
 - Your public RSA key has been added to the [ authorized_keys ] file.
 - The permissions for the [ authorized_keys ] file have been changed to 0600 (rw-------).

Create a new file or check an existing file named [ config ] in the local [ /home/toafez/.ssh ] subdirectory.
 - The [ config ] file has been created.
 - Your remote system [ Ubuntu-Server ] has been added to the [ config ] file.
 - The permissions for the [ config ] file have been changed to 0600 (rw-------).

Connect to the remote system [ 172.16.1.12 ] on port [ 22 ] to transfer the local public key to it.
 - Note: When establishing an SSH connection to a remote system for the first time, you must confirm the connection by entering 'yes'.
 - Please enter the password for the user [ tommes ] below to log in to the remote system...

/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/tommes/.ssh/id_rsa.pub"
The authenticity of host '172.16.1.12 (172.16.1.12)' can't be established.
ED25519 key fingerprint is SHA256:FpuLT9KReC0Ha4faxNPbDnilBYVb+77Zg3ObEk7ZuVM.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
tommes@172.16.1.12's password: 

Number of key(s) added: 1

Now try logging into the machine, with: "ssh -i /home/tommes/.ssh/id_rsa -p 22 'tommes@172.16.1.12'"
and check to make sure that only the key(s) you wanted were added.


All operations completed. Disconnect!
```

## Versionsgeschichte
- Details zur Versionsgeschichte findest du in der Datei [CHANGELOG](CHANGELOG)

## Hilfe und Diskussion
- Comming soon!

## Lizenz
- MIT License [LICENSE](LICENSE)