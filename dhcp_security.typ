#import "chapters/global.typ": *
#import "chapters/fblib.typ": *
#import "chapters/glossary-definitions.typ": gls-entries
#register-glossary(gls-entries)
#show: make-glossary

// Das Template schreibt im Exposé-Modus fix "Exposé" auf die Titelseite;
// für diese Abgabe wird stattdessen "Projektarbeit" angezeigt.
#show "Exposé": "Projektarbeit"

#show: doc => thesis(
// Status of the document
draft: false,
// Abgabe statt Thesis: schlanke Titelseite ohne Abstract-Seite und
// ohne "Master's Thesis"-Angaben (Verzeichnisse werden unten selbst erzeugt)
expose: true,
// Logo should be ok for a thesis at IIT, the
// Institute of Software Design and Security (see https://www.fh-joanneum.at/iit)
logo: image("./figures/logo.svg", width: 32%),
// Your study programme
// Master:
//   ims ... IT & Mobile Security (see https://www.fh-joanneum.at/ims)
//   irm ... IT-Recht & Management (see https://www.fh-joanneum.at/irm)
// Bachelor:
//   swd ... Software Design & Cloud Computing (VZ) (see https://www.fh-joanneum.at/itm)
//   swd ... Software Design & Cloud Computing (BB) (see https://www.fh-joanneum.at/swd)
//   msd ... Mobile Software Development (see https://www.fh-joanneum.at/msd)
study: "ims", // ims, irm, swd, msd
// For study programme "ims" the language is required to be in English
language: "de", // en, de
title: "DHCP-Security Attacks & Mitigation",
// Optional subtitle. Set to none if you do not need a subtitle.
subtitle: [Praxisorientierte Analyse für die LV Basic Network Security.],
supervisor: "DI (FH) Florian TEMEL, MSc, MSc",
author: "Florian Bilek, Mat: 08604600",
// E.g. "Dezember 2025" or "Dec / 2025"
submission-date: "Dezember 2026",
// Abstract entfällt: abstract-en wird vom Template verlangt, daher leer;
// abstract-ge ist optional und damit none.
abstract-ge: none,
abstract-en: [],
// Keine Keywords (würden sonst auf der Abstract-Seite erscheinen)
keywords: none,
// Enable/disable outlines for "listings", "tables","equations", and/or "figures"
show-list-of: ("figures"),
// The *.bib file with the bibliography entries
biblio: bibliography("biblio.bib", title: [Quellen], style: "./biblio.csl"),
// Do not change this
// Note: 'doc' stands for the rest of this file, the documement
//
doc,
)

#show heading.where(level: 1): set heading(supplement: [Kapitel])
#show heading.where(level: 2): set heading(supplement: [Abschnitt])

#outline(title: [Inhaltsverzeichnis], depth: 3, indent: 1.5em)
#pagebreak()

= Einleitung und Zielsetzung

Das Dynamic Host Configuration Protocol (DHCP) gehört zu den grundlegenden Diensten moderner IP-Netzwerke. Es ermöglicht die automatische Zuweisung von IPv4-Adressen sowie weiterer Konfigurationsparameter, beispielsweise Subnetzmaske, Standardgateway, DNS-Server und Gültigkeitsdauer der Adresszuweisung. Gerade in Netzen mit vielen wechselnden Endgeräten reduziert DHCP den administrativen Aufwand erheblich. Gleichzeitig setzt seine klassische Funktionsweise voraus, dass ein Client beim erstmaligen Kontakt noch über keine gültige IPv4-Konfiguration verfügt. Die dafür notwendige Kommunikation erfolgt anfänglich durch Broadcast-Nachrichten im lokalen Netzsegment.

Diese Eigenschaft eröffnet Angriffsflächen auf der Sicherungsschicht beziehungsweise an der Schnittstelle zwischen Layer 2 und Layer 3. Zwei besonders anschauliche Szenarien sind _DHCP Starvation_ und der Einsatz eines _Rogue DHCP Servers_. Bei DHCP Starvation versucht ein Angreifer, den verfügbaren Pool dynamischer Adressen durch eine große Anzahl scheinbar unterschiedlicher Clients aufzubrauchen. Bei einem Rogue-DHCP-Angriff tritt hingegen ein nicht autorisierter DHCP-Server auf und übermittelt dem Opfer manipulierte Netzwerkkonfigurationen. Beide Verfahren können die Verfügbarkeit oder die Vertrauenswürdigkeit der Netzwerkkonfiguration beeinträchtigen.

Ziel dieser Projektarbeit ist die Untersuchung beider Angriffsszenarien in einer abgeschlossenen, virtualisierten Laborumgebung sowie die Bewertung geeigneter Schutzmaßnahmen. Als Versuchsplattform dient gemäß der Projektvorgabe @projektvorgabe eine Linux-VM mit Docker-Containern und einer isolierten Bridge. Ein regulärer DHCP-Server, ein Client und ein Angreifer bilden die beteiligten Rollen. Der fehlerfreie DHCP-Ablauf wird zunächst als Referenz aufgezeichnet. Anschließend sollen die Auswirkungen der beiden Angriffsszenarien anhand von Paketmitschnitten und der tatsächlich übernommenen Clientkonfiguration überprüft werden. Die Abwehr wird exemplarisch durch eine Filterregel auf dem Docker-Host nachgebildet, die DHCP-Serverantworten vom Angreiferport unterbindet.

Die Untersuchung verbindet damit drei Perspektiven: das Protokollverhalten nach RFC 2131 @rfc2131, die technische Reproduzierbarkeit in einem Linux-Labor und die Einordnung praktischer Sicherheitsmaßnahmen wie DHCP Snooping und Port Security. Die geplanten Prüfungen sind von bereits nachgewiesenen Ergebnissen zu unterscheiden: Wo noch keine eigenen Messdaten oder Paketmitschnitte vorliegen, werden im Folgenden erwartete Beobachtungen und belastbare Prüfkriterien angegeben, nicht fingierte Versuchsergebnisse.

= Technische Grundlagen

== Funktionsweise von DHCPv4

DHCPv4 ist in RFC 2131 spezifiziert und baut auf UDP auf @rfc2131. Der Server verwendet üblicherweise UDP-Port 67, der Client UDP-Port 68; diese Portzuordnung stammt vom Vorgängerprotokoll BOOTP @rfc951. Ein Client, der noch keine gültige Adresse besitzt, kann daher zu Beginn über die Quelladresse `0.0.0.0` und die Broadcast-Adresse `255.255.255.255` kommunizieren. Im lokalen Ethernet-Netz werden die entsprechenden Frames gegebenenfalls als Broadcast verteilt. Ein DHCP-Relay kann die Kommunikation über Subnetzgrenzen hinweg vermitteln; im hier vorgesehenen Labor befinden sich die Beteiligten jedoch im selben Broadcast-Segment.

Die erste reguläre Adressvergabe wird häufig mit dem Akronym DORA beschrieben. Es steht für _Discover_, _Offer_, _Request_ und _Acknowledgment_. Der Client sendet zunächst ein `DHCPDISCOVER`, um verfügbare Server zu suchen. Ein Server antwortet mit einem `DHCPOFFER`, das unter anderem eine angebotene Adresse und Konfigurationsoptionen enthält. Daraufhin wählt der Client ein Angebot aus und signalisiert mit `DHCPREQUEST`, von welchem Server er die Adresse beziehen möchte. Abschließend bestätigt der ausgewählte Server die Vergabe mit `DHCPACK`. Erst danach wird die Konfiguration vom Client regulär aktiviert.

#table(
  columns: (1.2fr, 1.2fr, 2.6fr),
  inset: 6pt,
  [*Nachricht*], [*Richtung*], [*Bedeutung*],
  [`DHCPDISCOVER`], [Client → Server], [Suche nach DHCP-Servern],
  [`DHCPOFFER`], [Server → Client], [Angebot einer Adresse und von Optionen],
  [`DHCPREQUEST`], [Client → Server], [Auswahl beziehungsweise Anforderung einer Adresse],
  [`DHCPACK`], [Server → Client], [Bestätigung der Adresszuweisung],
)

Der DORA-Ablauf ist nicht mit einer allgemein zustandslosen Implementierung von DHCP gleichzusetzen. Ein DHCP-Server verwaltet durchaus Lease-Zustände und Zuordnungen. Die sicherheitsrelevante Schwäche ist vielmehr, dass die grundlegenden DORA-Nachrichten im klassischen DHCPv4 nicht durch eine standardmäßig eingesetzte gegenseitige Authentisierung von Client und Server geschützt sind. Eine Erweiterung zur Authentisierung von DHCP-Nachrichten ist zwar in RFC 3118 spezifiziert @rfc3118, wird in der Praxis jedoch kaum eingesetzt. Ein Endgerät kann daher nicht allein aus dem Empfang eines `DHCPOFFER` ableiten, dass die Antwort von einem autorisierten Server stammt. Umgekehrt ist eine vom Client gemeldete Hardwareadresse kein zuverlässiger Identitätsnachweis.

== DHCP-Leases und Konfigurationsoptionen

Eine zugewiesene IPv4-Adresse wird normalerweise nur für einen begrenzten Zeitraum, die sogenannte Lease Time, vergeben. Ein Client kann diese Zuweisung vor ihrem Ablauf erneuern. Ein DHCP-Server muss hierfür nachvollziehen können, welche Adressen vergeben, angeboten oder wieder verfügbar sind. Die Auswirkung eines Starvation-Angriffs hängt deshalb sowohl von der Poolgröße als auch vom konkreten Verhalten des Servers bei Angeboten, Bestätigungen, abgelaufenen Leases und Identifikatoren ab.

Für das Rogue-DHCP-Szenario ist insbesondere die Router-Option relevant. Die DHCP-Option 3 benennt einen oder mehrere Standardrouter für das Clientnetz @rfc2132. Eine unautorisierte Änderung kann bewirken, dass Pakete an Ziele außerhalb des lokalen Subnetzes über einen vom Angreifer bezeichneten Router gesendet werden. Ebenso können manipulierte DNS-Einstellungen ein Sicherheitsproblem darstellen. Dabei ist zwischen einer angebotenen Konfiguration in einem Paketmitschnitt und einer tatsächlich vom Betriebssystem übernommenen Routingtabelle zu unterscheiden.

== Vertrauensgrenzen im lokalen Netz

Ein Ethernet-Switch behandelt gewöhnliche Broadcasts innerhalb einer VLAN- beziehungsweise Broadcast-Domäne nicht als vertrauenswürdige oder unvertrauenswürdige Inhalte. Wenn keine speziellen Schutzfunktionen aktiv sind, kann deshalb grundsätzlich jedes Gerät innerhalb derselben Domäne DHCP-Servernachrichten senden. Die Angriffsfläche ergibt sich gerade aus dem Zusammentreffen von offenem Broadcast-Verkehr, nicht authentisierten Protokollrollen und automatischer Übernahme von Konfigurationsinformationen.

Eine zweckmäßige Schutzstrategie setzt vor der Verarbeitung solcher Nachrichten an. Auf einem gemanagten Switch können ausgewählte Ports als vertrauenswürdig festgelegt werden; an Zugangsports zu Endgeräten werden Serverantworten dann verworfen. Ergänzende Maßnahmen begrenzen die Anzahl verwendbarer MAC-Adressen beziehungsweise die Rate eingehender DHCP-Nachrichten. Entscheidend ist, dass die Schutzfunktion dort ansetzt, wo die Frames in die jeweilige Layer-2-Domäne eintreten.

= Bedrohungsmodell und Laborarchitektur

== Abgrenzung des Versuchs

Die praktische Untersuchung findet ausschließlich in einer isolierten Linux-VM statt. Das Testnetz ist für das Subnetz `192.168.50.0/24` vorgesehen. Die Bridge `br-dhcp` übernimmt die Rolle eines softwarebasierten Switch-Fabrics. Der autorisierte DHCP-Server bietet Adressen im Bereich `192.168.50.100` bis `192.168.50.150` an. Als reguläres Standardgateway ist `192.168.50.1` vorgesehen. Der Angreifer soll im Rogue-Szenario stattdessen die Adresse `192.168.50.66` als Gateway verteilen.

Die beteiligten Komponenten und Rollen ergeben sich aus folgender Übersicht:

#table(
  columns: (1.3fr, 1.4fr, 2.3fr),
  inset: 6pt,
  [*Komponente*], [*Umsetzung*], [*Rolle*],
  [`dhcp-server`], [Alpine Linux, `dnsmasq`], [Autorisierte DHCP-Konfiguration und definierter Adresspool],
  [`victim-client`], [Alpine Linux, DHCP-Client], [Legitimer Empfänger der Netzwerkkonfiguration],
  [`attacker`], [Kali Linux, Scapy, Yersinia, `dnsmasq`], [Simulation von Starvation und Rogue DHCP],
  [Linux-Host], [Docker-Bridge, `tcpdump`, Netfilter], [Virtuelle Netzverbindung, Beobachtung und Filterung],
)

Die Adressangaben erfüllen unterschiedliche Funktionen: Das Subnetz beschreibt die gemeinsame Layer-2-Testdomäne; der Pool grenzt dynamisch zugewiesene Adressen ein; `.1` repräsentiert die autorisierte Router-Option und `.66` die im Angriffsfall manipulierte Router-Option. Für die Interpretation des Versuchs muss ausdrücklich dokumentiert werden, ob unter `.1` beziehungsweise `.66` tatsächlich ein Router erreichbar ist. Schon eine abweichende DHCP-Router-Option ist nachweisbar, ohne dass damit automatisch eine erfolgreiche Umleitung nutzbarer Internetverbindungen bewiesen wäre.

== Besonderheiten von Docker-Bridge-Netzen

Eine Docker-Bridge ist zwar technisch eine Linux-Bridge auf Layer 2 @linux-bridge, sie entspricht jedoch nicht in allen Eigenschaften einem verwaltbaren Enterprise-Switch. Eine gewöhnliche benutzerdefinierte Docker-Bridge wird vom Docker-Netzwerkmanagement verwaltet; Docker weist Containern standardmäßig selbst IP-Adressen zu und setzt NAT- beziehungsweise Firewallregeln @docker-bridge. Die Adresszuweisung durch Docker ist nicht mit der im Labor zu testenden DHCP-Adressvergabe identisch.

Damit eine DHCP-Anfrage nicht lediglich auf dem Papier simuliert wird, muss überprüft werden, dass der Client tatsächlich einen DHCP-Client innerhalb seines Network Namespace ausführt, passende Rechte besitzt und die vom DHCP-Server angebotene Konfiguration aktivieren kann. Für diesen Zweck kann eine kontrolliert aufgebaute Linux-Bridge mit expliziten `veth`-Verbindungen und Containern ohne automatische Docker-IP-Konfiguration die transparentere Variante darstellen. Das im Projektplan genannte Docker-Bridge-Konzept bleibt dabei die Ausgangsarchitektur; notwendige Abweichungen von einer Standard-Docker-Konfiguration sind im praktischen Bericht festzuhalten.

Auch der Name der Bridge muss überprüft werden: Ein Docker-Netzwerk mit einem bestimmten Namen garantiert nicht automatisch, dass das zugehörige Linux-Interface denselben Namen trägt. Die Aufzeichnung mit `tcpdump -i br-dhcp` funktioniert nur, wenn dieses Interface auf dem Host tatsächlich existiert. Vor jedem Versuch ist daher der reale Name der Bridge mittels `ip link` oder `bridge link` zu kontrollieren.

== Isolierung und Wiederholbarkeit

Für belastbare Ergebnisse werden alle Versuche nur im abgeschotteten Testnetz durchgeführt. Die Laborumgebung darf keine DHCP-Nachrichten in das physische Campus-, Heim- oder Unternehmensnetz weiterleiten. Eine direkte Anbindung der Angreifer-Bridge an fremde Broadcast-Domänen wäre sowohl methodisch unnötig als auch sicherheitskritisch. Die Paketaufzeichnung, die Dienstkonfigurationen und der Zustand der Lease-Datei sollten vor einem neuen Versuch dokumentiert werden.

Eine reproduzierbare Untersuchung benötigt außerdem einen definierten Anfangszustand. Dazu zählen die Größe des freien Adresspools, laufende DHCP-Dienste, die Konfiguration der Netzwerkschnittstellen, die Filterregeln des Hosts und die bereits existierenden Leases. Zwischen den Versuchsdurchläufen werden DHCP-Zustände nur kontrolliert und dokumentiert zurückgesetzt. Andernfalls könnten nicht freigegebene Alt-Leases fälschlich als Auswirkung eines neuen Angriffs interpretiert werden.

= Referenzversuch: Regulärer DHCP-Ablauf

== Vorgehensweise

Der erste Versuch dient als Baseline und ist die Grundlage sämtlicher späterer Vergleiche. Zunächst wird ausschließlich der autorisierte DHCP-Server betrieben; der Rogue-Dienst ist deaktiviert. Auf dem Docker-Host wird der Verkehr auf der tatsächlich verwendeten Bridge erfasst. Der Projektplan sieht dafür folgende Aufzeichnung mit `tcpdump` @tcpdump vor:

```sh
tcpdump -i br-dhcp -nn -s 0 -w dhcp_demo.pcap 'udp port 67 or udp port 68'
```

Die Filterung beschränkt sich auf DHCPv4-Verkehr und reduziert irrelevante Pakete. Während die Aufzeichnung läuft, wird die DHCP-Anfrage des Clients ausgelöst. Hierzu kann entsprechend dem Projektplan der in Alpine gebräuchliche Client `udhcpc` verwendet werden. Die genaue Schnittstelle muss an die tatsächliche Containerkonfiguration angepasst werden; der Client darf dabei keine produktive Netzwerkschnittstelle verändern.

In der ursprünglichen Komponentenliste wird `dhclient` als Standard-Client genannt, während der Demonstrationsablauf `udhcpc` vorsieht. Diese beiden Programme sind unterschiedliche DHCP-Implementierungen. Für eine konsistente Versuchsdokumentation sollte eines davon ausgewählt, mit Version und Befehlsaufruf angegeben und durchgehend verwendet werden. Unter Alpine ist `udhcpc` häufig die unkompliziertere Wahl.

== Auswertung des Paketmitschnitts

Im idealen Normalfall erscheint die Folge `DHCPDISCOVER`, `DHCPOFFER`, `DHCPREQUEST` und `DHCPACK`. Bei der Auswertung sind nicht nur die Nachrichtentypen, sondern auch die Zuordnung der Nachrichten zu einer Transaktion relevant. Dafür eignen sich die Transaction ID (`xid`), die Client-Hardwareadresse beziehungsweise Client-ID, die Server Identifier Option und die angebotene Adresse.

Die DORA-Abfolge sollte in einem Paketanalysator wie Wireshark anhand dieser Felder nachgezeichnet werden. Zu prüfen sind insbesondere die in der Antwort enthaltene Router-Option, die Lease Time, die Serverkennung und die schließlich am Client konfigurierte IPv4-Adresse. Werden mehrere DHCP-Server angeboten, können weitere Offers auftreten; gerade deshalb ist die Baseline mit nur einem aktiven Server sinnvoll.

Die erwartete Referenzbeobachtung lautet: Der Client erhält eine Adresse aus dem Bereich `192.168.50.100–192.168.50.150`; der übermittelte Standardrouter ist `192.168.50.1`; im Mitschnitt ist eine logisch zusammengehörige DORA-Transaktion erkennbar. Ob diese Beobachtungen tatsächlich erfüllt sind, muss durch einen eigenen Mitschnitt und die Netzwerkdiagnose des Clients belegt werden. Ein isoliertes `DHCPOFFER` allein reicht nicht aus, um eine erfolgreiche Konfiguration nachzuweisen.

= Angriffsszenario I: DHCP Starvation

== Angriffsidee und technische Voraussetzungen

DHCP Starvation bezeichnet eine Verfügbarkeitsattacke gegen den DHCP-Dienst. Der Angreifer erzeugt eine große Zahl scheinbar unabhängiger DHCP-Anfragen, um den Adresspool eines Servers zu belegen beziehungsweise dessen Ressourcen zu erschöpfen. Der im Projektplan vorgesehene Ansatz nutzt Scapy zur Erzeugung von DHCP-Nachrichten mit wechselnden, gefälschten MAC-Adressen. Damit soll der legitime Server die Anfragen als von unterschiedlichen Clients stammend behandeln.

Es ist jedoch wichtig, zwischen `DISCOVER`-Paketen, angebotenen Adressen und verbindlich zugeordneten Leases zu unterscheiden. Nicht jeder DHCP-Server reserviert eine Adresse bereits dauerhaft beim Empfang eines einzelnen `DHCPDISCOVER`. Je nach Implementierung sind für eine nachhaltige Erschöpfung weitere Schritte der regulären Adressanforderung, bestimmte Identifikatoren oder ein ausreichender Zeitraum erforderlich. Die reine Menge gesendeter Discover-Nachrichten ist somit kein belastbarer Erfolgsbeleg.

Die Identität eines DHCP-Clients kann außerdem über mehr als nur die Ethernet-Quell-MAC-Adresse ermittelt werden. In DHCP-Paketen existiert das Feld `chaddr`, und optional kann eine Client Identifier Option (Option 61) verwendet werden @rfc2131 @rfc2132. Diese Werte sowie der tatsächlich vom Server verarbeitete Clientbezug müssen in der Auswertung berücksichtigt werden. Werden nur Ethernet-Adressen verändert, die DHCP-Identifikatoren aber gleich gelassen, kann das erwartete Verhalten ausbleiben.

== Kontrollierter Laborversuch

Der Versuch wird in einer eigenen Phase mit deaktiviertem Rogue-DHCP-Server durchgeführt. Zu Beginn ist die Zahl freier Leases zu dokumentieren. Danach wird das Scapy-basierte @scapy Testprogramm ausschließlich auf dem isolierten Angreifercontainer ausgeführt. Die Last wird kontrolliert gesteigert; gleichzeitig zeichnet `tcpdump` die DHCP-Pakete auf. Die genaue Anzahl der versendeten Nachrichten sowie der zeitliche Verlauf werden protokolliert.

Für die Messung sind mehrere Ebenen voneinander zu trennen: (1) Wie viele unterschiedliche Clientidentitäten wurden tatsächlich versendet? (2) Wie viele Angebote und Bestätigungen antwortet der Server? (3) Wie verändert sich die Liste der gültigen beziehungsweise reservierten Leases? (4) Erhält ein zusätzlich gestarteter legitimer Client noch eine Adresse? Erst die Kombination dieser Informationen erlaubt die Aussage, dass der Dienst in seiner Verfügbarkeit beeinträchtigt wurde.

Im vorgesehenen Adresspool liegen einschließlich der beiden Grenzen 51 IPv4-Adressen. Unter idealisierten Bedingungen und ohne bestehende Belegungen entspricht dies 51 gleichzeitig möglichen Zuweisungen. Praktisch kann die Zahl der nutzbaren Adressen von Konfiguration, Reservierungen und dem aktuellen Zustand des Servers abhängen. Die mathematische Poolgröße ist deshalb mit dem tatsächlich verfügbaren Lease-Bestand zu vergleichen.

== Erwartete Auswirkungen und Grenzen

Wenn sämtliche verfügbaren Adressen bereits anderen Clientidentitäten zugeordnet sind, kann eine weitere legitime Anforderung ohne gültiges Angebot bleiben. Für das Opfer bedeutet dies, dass es möglicherweise keine einsatzfähige DHCP-Konfiguration erhält. Ein solcher Zustand ist ein Denial of Service gegenüber der automatischen IPv4-Konfiguration. Bereits bestehende Leases können dagegen zunächst weiter funktionieren; die Attacke bedeutet nicht zwingend, dass jedes bereits verbundene Gerät sofort seine Konnektivität verliert.

Als Erfolgskriterium sollte daher nicht die bloße Präsenz vieler Discover-Pakete formuliert werden, sondern ein konkret überprüfbarer Zustand: Der verfügbare Pool ist nachweislich erschöpft und eine erneute legitime Adressanforderung scheitert unter ansonsten vergleichbaren Bedingungen. Falls der Server unbestätigte Angebote schnell verwirft oder doppelte Clientidentifikatoren zusammenfasst, kann der geplante Angriff trotz hoher Paketanzahl wirkungslos bleiben. Auch dieses negative Ergebnis ist für die Sicherheitsbewertung relevant, weil es die Abhängigkeit vom implementierten Serververhalten zeigt.

= Angriffsszenario II: Rogue DHCP Server

== Angriffsidee

Ein Rogue DHCP Server ist ein nicht autorisierter Dienst, der auf DHCP-Anfragen antwortet und dabei als scheinbar regulärer Konfigurationsserver auftritt. Während DHCP Starvation primär die Verfügbarkeit betrifft, steht hier die Integrität der Netzwerkkonfiguration im Vordergrund. Der Angreifer kann einem Client unter anderem eine falsche Router- oder DNS-Option anbieten. Bei erfolgreicher Übernahme kann dies zu Verbindungsproblemen, zur Umlenkung des Datenverkehrs oder zur Unterstützung weiterer Angriffe führen.

Für das Labor ist vorgesehen, auf dem Kali-Container einen zweiten `dnsmasq`-Dienst @dnsmasq zu betreiben. Dieser Dienst bietet eine manipulierte Router-Option mit dem Wert `192.168.50.66` an. Der legitime Server gibt dagegen `192.168.50.1` aus. Weil der Client anfangs beide DHCP-Server über dasselbe Broadcast-Segment erreichen kann, können mehrere Angebote auf eine Anfrage folgen.

== Durchführung und Beobachtung

Nach einem erfolgreich dokumentierten Referenzversuch wird zusätzlich der Rogue-Dienst gestartet. Die relevante Router-Option muss vor dem Versuch nachweisbar in dessen Konfiguration gesetzt sein. Anschließend wird am Opfer eine neue DHCP-Adressvergabe ausgelöst und der gesamte Vorgang erneut aufgezeichnet. In Wireshark ist zu ermitteln, welche DHCP-Server antworten, welche angebotenen Einstellungen sie übermitteln und welchen Server der Client in seinem `DHCPREQUEST` auswählt.

Der Ablauf ist kein garantiertes Rennen, das stets der schnellere Server gewinnt. Das Verhalten hängt unter anderem von der Clientimplementierung, Antwortreihenfolge, vorhandenen Leases und weiteren Auswahlregeln ab. Ein empfangenes bösartiges Angebot beweist daher noch nicht die erfolgreiche Manipulation. Erst wenn die Antwort des Rogue-Servers ausgewählt und bestätigt wurde und die Routingtabelle des Opfers anschließend `192.168.50.66` als Default Gateway enthält, ist das zentrale Versuchsziel erreicht.

Zur eindeutigen Beweissicherung werden mindestens drei Elemente benötigt: ein Mitschnitt mit dem Rogue-`DHCPOFFER`, die zugehörige Serverauswahl beziehungsweise Bestätigung und ein Client-Nachweis der übernommenen Route. Bei einem Scheitern muss vermerkt werden, ob die Rogue-Antwort nicht angekommen ist, der Client sie nicht ausgewählt hat oder die angebotene Route nicht aktiviert wurde.

== Sicherheitsfolgen

Ein manipuliertes Gateway kann den Kommunikationspfad zu entfernten Netzwerken verändern. Ob dadurch tatsächlich ein Man-in-the-Middle-Angriff möglich wird, hängt davon ab, ob der bezeichnete Router Datenverkehr annimmt, weiterleitet und gegebenenfalls Rückwege vorhanden sind. Ist `.66` kein funktionsfähiger Router, kann stattdessen ein Ausfall der externen Kommunikation eintreten. Der Nachweis einer geänderten Routingtabelle ist somit nicht gleichbedeutend mit dem Nachweis mitgelesener oder erfolgreich weitergeleiteter Nutzdaten.

Mit dem Rogue-Verfahren wird eine grundsätzliche Vertrauensschwäche des DHCPv4-Protokolls sichtbar: Ein Client hat ohne ergänzende Netzwerkschutzmaßnahmen keine einfache Garantie, dass eine Netzwerkkonfiguration von der vorgesehenen administrativen Instanz stammt. Der Schutz muss deshalb häufig in der Infrastruktur implementiert werden, bevor unerwünschte Serverantworten beim Endgerät ankommen.

= Schutzmaßnahmen auf Layer 2 und Hostebene

== DHCP Snooping

DHCP Snooping ist eine Schutzfunktion gemanagter Switches, bei der DHCP-Verkehr anhand der Vertrauensstellung des Eingangsports kontrolliert wird. Ports in Richtung autorisierter DHCP-Server beziehungsweise geeigneter Uplinks werden als _trusted_ eingestuft, während Anschlüsse gewöhnlicher Endgeräte als _untrusted_ gelten. Serverartige Antworten, die über einen untrusted Port eintreffen, werden verworfen. Auf diese Weise verhindert die Infrastruktur, dass ein beliebiger Clientanschluss zur Quelle gültiger DHCP-Servernachrichten werden kann.

Viele Implementierungen erstellen zusätzlich eine sogenannte Binding-Tabelle. Darin können unter anderem MAC-Adresse, zugewiesene IP-Adresse, VLAN, Port und Lease-Informationen erfasst werden. Solche Daten sind eine Grundlage für weitere Schutzfunktionen wie Dynamic ARP Inspection oder IP Source Guard. Die exakten Fähigkeiten hängen vom verwendeten Switch und dessen Betriebssystem ab. RFC 7513 beschreibt einen damit verwandten Ansatz zur Validierung von Quelladressen auf Basis von DHCP-Bindings @rfc7513.

Für die vorliegende Arbeit ist die Port-Vertrauensgrenze der entscheidende Punkt: DHCP-Antworten des offiziellen Servers müssen weiterhin zugelassen werden, die eines an einem untrusted Port angeschlossenen Angreifers dagegen nicht. DHCP Snooping ist dabei keine Authentisierung der DHCP-Nachrichten durch den Client selbst, sondern eine netzwerkinfrastrukturseitige Kontrolle des Kommunikationswegs.

== Port Security und Rate Limiting

Port Security begrenzt auf gemanagten Switches die an einem Port zulässigen beziehungsweise erlernten MAC-Adressen. Dadurch lässt sich die Verwendung sehr vieler unterschiedlicher Quell-MAC-Adressen an einem einzelnen Zugangsport erschweren. Für DHCP Starvation ist dies relevant, weil der geplante Angriff mit wechselnden vorgetäuschten MAC-Adressen arbeitet. Abhängig von der Konfiguration kann ein Switch zusätzliche MAC-Adressen verwerfen oder den Port bei einer Regelverletzung in einen Schutzstatus versetzen.

Port Security allein ist jedoch kein vollständiger Schutz vor jeder Form von DHCP Starvation. Ein Angriff kann andere DHCP-Identifikatoren verwenden, ohne zwingend viele Ethernet-Quelladressen zu benötigen. Deshalb sind spezifische DHCP-Rate-Limits an untrusted Ports sowie Kontrollen von DHCP-Nachrichtentypen eine wichtige Ergänzung. Eine zu niedrig gewählte Schwelle kann allerdings legitime Clients beeinträchtigen, etwa wenn nach einem Stromausfall viele Geräte gleichzeitig neue Leases anfordern.

Die beiden Schutzansätze haben damit unterschiedliche Schwerpunkte: DHCP Snooping kontrolliert vor allem, von welchen Anschlüssen Serverantworten stammen dürfen; Port Security begrenzt die Anzahl beziehungsweise Dynamik der MAC-Identitäten an einem Anschluss. Sie ergänzen einander, sind aber nicht austauschbar.

== Netfilter als softwarebasierte Nachbildung

Im Projektplan wird die Funktion eines untrusted Switchports mithilfe von Netfilter auf dem Debian-Host nachgebildet. Die beabsichtigte Regel lautet sinngemäß: DHCP-Serverantworten, die vom virtuellen Anschluss des Angreifers eintreffen, werden verworfen; entsprechende Antworten des autorisierten Servers dürfen die Bridge passieren. Für die Zuordnung ist der tatsächliche Host-seitige `veth`-Port des Angreifercontainers zu ermitteln.

Bei rein gebridgtem Verkehr ist die Wahl des Filter-Hooks wesentlich. Eine einfache IPv4-Regel in einer gewöhnlichen `iptables`-`FORWARD`-Kette greift bei Linux-Bridge-Verkehr nicht unter allen Bedingungen; dies hängt unter anderem von der aktiven Bridge-Netfilter-Konfiguration ab. Der direkte und technisch besser abgegrenzte Ansatz ist eine `nftables`-Tabelle der Familie `bridge`, deren Forward-Hook Ethernet-Frames beim Weiterleiten über die Bridge überprüft @nftables-bridge.

Ein schematisches Beispiel für die Filterlogik lautet:

```nft
# Beispiel: <angreifer-veth> durch den ermittelten Portnamen ersetzen
# Nur im isolierten Labor anwenden.
table bridge dhcp_guard {
  chain forward {
    type filter hook forward priority 0; policy accept;
    iifname "<angreifer-veth>" ether type ip \
      ip protocol udp udp sport 67 udp dport 68 drop
  }
}
```

Die Regel verwirft DHCPv4-Antworten von UDP-Quellport 67 an UDP-Zielport 68, wenn sie über den definierten Angreiferanschluss in die Bridge gelangen. Damit wird gezielt ein Teil der DHCP-Snooping-Funktion nachgebildet. Sie bildet weder eine vollständige DHCP-Snooping-Binding-Tabelle noch Port Security nach und schützt auch nicht automatisch gegen alle denkbaren manipulativen Pakete. Insbesondere muss bei der Verifikation geprüft werden, ob die verwendeten DHCP-Pakete tatsächlich über den erwarteten Bridge-Forward-Pfad laufen und ob weitere Transportvarianten gesondert berücksichtigt werden müssten.

Die Wirksamkeit der Regel wird durch einen Vorher-nachher-Vergleich belegt. Ohne Filter soll das Opfer im Rogue-Versuch zumindest potenziell Angebote beider Server empfangen. Nach Aktivierung der Regel soll weiterhin das autorisierte `DHCPOFFER` eintreffen, während Antworten des Rogue-Servers auf dem Weg zum Client unterdrückt werden. Dazu werden die nftables-Regelzähler, Paketmitschnitte am passenden Messpunkt und die abschließende Clientkonfiguration verglichen. Eine Aufnahme direkt an der Bridge kann je nach Capture-Punkt auch verworfene Frames sichtbar machen; daraus darf nicht automatisch geschlossen werden, dass das Paket beim Client angekommen ist.

= Validierung und Bewertung

== Messkriterien

Um die Sicherheitswirkung nicht allein aus theoretischen Annahmen abzuleiten, werden die relevanten Größen vor und nach jeder Maßnahme erfasst. Die folgende Matrix verbindet die Phasen der Arbeit mit konkreten Prüfkriterien:

#table(
  columns: (1.1fr, 1.7fr, 2.1fr),
  inset: 6pt,
  [*Testphase*], [*Prüfgröße*], [*Erwarteter Befund*],
  [Baseline], [DORA, Client-IP, Gateway], [Gültige Pooladresse und Router `.1`],
  [Starvation], [Lease-Bestand, neue DHCP-Anfrage], [Pool erschöpft; zusätzliche legitime Anfrage scheitert],
  [Rogue DHCP], [Angebote, Serverauswahl, Default Route], [Gegebenenfalls Übernahme von Router `.66`],
  [Filter aktiv], [Regelzähler, Client-DORA, Default Route], [Rogue-Antwort unterdrückt; Router `.1` bleibt nutzbar],
)

Die Matrix enthält *erwartete* Ergebnisse. Sie ersetzt keine Messprotokolle. Beim späteren Verfassen des Ergebniskapitels müssen die tatsächlichen Beobachtungen für jede Zeile eingetragen und mit Paketnummern, Zeitstempeln, Konsolenausgaben oder Screenshots belegt werden. Weicht ein Messwert von der Erwartung ab, ist die Abweichung zu erläutern und darf nicht durch einen vorausgesetzten Erfolg überschrieben werden.

== Bewertung des Starvation-Versuchs

Die zentrale Frage ist, ob die Adressvergabe für einen zusätzlichen legitimen Client tatsächlich ausfällt. Eine große Menge DHCP-Verkehr kann Netzwerkressourcen belasten, muss aber nicht zwangsläufig eine dauerhafte Poolerschöpfung verursachen. Daher sind die Zahl der freien Leases, die Zuweisungsentscheidungen des Servers und die Reaktion des legitimen Clients gemeinsam zu bewerten. Als besonders aussagekräftig gilt ein Vergleich zwischen einer erfolgreichen Anfrage im Ausgangszustand und einer erfolglosen Anfrage nach belegtem Pool.

Für die Bewertung möglicher Gegenmaßnahmen sind Port Security und DHCP-Rate-Limiting als Schutzkonzepte zu untersuchen. Die im PDF vorgesehene Netfilter-Regel gegen DHCP-Serverantworten adressiert dagegen in erster Linie das Rogue-Szenario. Es wäre fachlich nicht korrekt, daraus ohne eigenen Test eine Abwehr von DHCP Starvation abzuleiten. Soll eine aktive Starvation-Mitigation demonstriert werden, ist eine separate Begrenzung der DHCP-Clientpakete beziehungsweise der zulässigen Identitäten erforderlich.

== Bewertung des Rogue-Versuchs

Hier ist die relevante Frage, ob die manipulierte Router-Option den Client erreicht und tatsächlich aktiviert wird. Das Vorhandensein eines zweiten DHCP-Servers im Broadcast-Segment ist bereits eine Sicherheitsauffälligkeit. Der vollständige Wirkungsnachweis setzt jedoch die Auswahl dieses Servers und die übernommene Konfiguration voraus. Wenn der Client das legitime Angebot auswählt, hat der konkrete Versuch keine Gateway-Manipulation bewirkt, obwohl die Gefährdung durch den Rogue-Server bestehen bleibt.

Die Filtermaßnahme gilt dann als erfolgreich nachgewiesen, wenn ein kontrollierter Vergleich zeigt, dass die Rogue-Serverantwort am relevanten Pfad unterdrückt wird und der Client weiterhin eine legitime Konfiguration beziehen kann. Eine Filterregel, die sämtliche DHCP-Antworten blockiert, wäre zwar gegen den Rogue-Server wirksam, würde jedoch die reguläre Netzfunktion zerstören und damit die Sicherheitsanforderung verfehlen.

== Grenzen der Aussagekraft

Ein Labor mit drei Containern bildet zentrale Protokollmechanismen verständlich ab, aber kein vollständig ausgestattetes Unternehmensnetz. Ein softwarebasierter Filter ist nicht identisch mit den Hardwarefunktionen moderner Switches. Auch lassen sich aus einem einzelnen erfolgreichen Angriff keine allgemeinen Wahrscheinlichkeiten über die Auswahl von DHCP-Servern oder die Robustheit aller DHCP-Implementierungen ableiten. Clientversion, Serverkonfiguration, Paketlaufzeiten und vorhandene Leases beeinflussen die Ergebnisse.

Weitere Grenzen ergeben sich aus dem Fokus auf DHCPv4 und eine einzelne Broadcast-Domäne. DHCPv6 verfügt über andere Nachrichtentypen und eigene Schutzanforderungen. Ebenso sind VLAN-übergreifende Relay-Szenarien, hochverfügbare DHCP-Server, echte Switch-Binding-Tabellen und komplexe Netzrichtlinien hier nicht Gegenstand der praktischen Umsetzung. Diese Einschränkungen sind kein Mangel des Experiments, solange die daraus gezogenen Schlussfolgerungen klar auf die untersuchte Umgebung bezogen bleiben.

= Schlussfolgerung

Die Arbeit untersucht, inwieweit ein ungeschützter DHCPv4-Betrieb auf Layer 2 von nicht autorisierten Teilnehmern beeinflusst werden kann. Der DORA-Ablauf erleichtert die automatische Inbetriebnahme von Geräten, sieht im üblichen Betrieb aber keine durchgesetzte gegenseitige Authentisierung von DHCP-Client und DHCP-Server vor. Daraus entstehen zwei unterschiedliche Risiken: Durch die missbräuchliche Belegung des Adresspools kann die Verfügbarkeit der Adressvergabe beeinträchtigt werden; durch einen Rogue-DHCP-Server können falsche Konfigurationsparameter angeboten und unter bestimmten Bedingungen übernommen werden.

Die geplante Docker-basierte Laborumgebung eignet sich, diese Risiken anhand von Netzwerkpaketen und Systemzuständen nachvollziehbar zu untersuchen. Entscheidend ist die saubere Trennung von gesendeten Nachrichten, vom Server bestätigten Leases und vom Client tatsächlich aktivierten Parametern. Erst überprüfbare Messdaten erlauben belastbare Aussagen über den Erfolg der einzelnen Angriffe.

Auf der Verteidigungsseite stehen DHCP Snooping, Port Security und DHCP-bezogenes Rate Limiting für komplementäre Schutzmechanismen. Die im Labor vorgesehene Netfilter-Regel demonstriert speziell das Prinzip des untrusted DHCP-Serverports, ersetzt jedoch keine vollständige Switch-Sicherheitsarchitektur. Eine robuste Härtung verbindet daher die Kontrolle autorisierter DHCP-Serverpfade mit einer angemessenen Begrenzung missbräuchlicher Clientaktivität sowie einer kontrollierten und dokumentierten Netzwerkkonfiguration. Die abschließende Bewertung sollte auf dem Vergleich von Baseline, Angriff und aktivierter Gegenmaßnahme beruhen.

// Quellenverzeichnis (wird vom Template aus biblio.bib erzeugt) auf eigener Seite
#pagebreak()
