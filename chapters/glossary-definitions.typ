// * Add list of terms

#let gls-entries = (

  (
    key: "4004", short: "4004", long: "Intel 4004", description: [Intel 4004 Microprocessor]
  ), 
  (
    key: "8008", short: "8008", long: "Intel 8008", description: [Intel 8008 Microprocessor]
  ), 
  (
    key: "8080", short: "8080", long: "Intel 8080", description: [Intel 8080 Microprocessor, für den Mikroprozessormarkt]
  ), 
  (
    key: "8085", short: "8085", long: "Intel 8085", description: [Intel 8085 Microprocessor]
  ), 
  (
    key: "8086", short: "8086", long: "Intel 8086", description: [Intel 8086 Microprocessor]
  ), 
  (
    key: "AR", short: "AR", long: "Access Register", description: [Access Register der IBM Z CPU]
  ), 
  (
    key: "AIU", short: "AIU", long: "Artificial Intelligence Unit", description: [In den IBM Telum-Prozessoren integrierte KI-Beschleunigungseinheit]
  ), 
  (
   key: "AMD", short: "AMD", long: "Advanced Micro Devices, Inc.", description: [US-amerikanisches Technologieunternehmen und der Hauptkonkurrent von Intel auf dem Markt für Computerchips.]
  ),
  (
   key: "AMD64", short: "AMD64", long: "AMD64", description: [64-Bit-Erweiterung der x86-Architektur mit vollständiger Rückwärtskompatibilität zu 32- und 16-Bit-x86, entwickelt von AMD.]
  ),
  ( 
   key: "ARM", short: "ARM", long: "Acorn RISC Machines", description: [später zu Advanced RISC Machines umbenannt. Britische Firma, die auf die Entwicklung von RISC-Prozessorarchitekturen spezialisiert ist.]
  ), 
  (
   key: "ASIC", short: "ASIC", long:"Application-Specific Integrated Circuits", description: [ASIC sind im Gegensatz zu Standard-Mikroprozessoren für spezifische Funktionen konzipiert und gefertigt.]
  ),
  (
   key: "AVX", short: "AVX", long:"Advanced Vector Extensions", description: [AVX bezeichnet eine Erweiterung des x86_64-Befehlssatzes im Jahr *2011* zur Ausführung von Vektor- und SIMD-Operationen]
  ),
  (
   key: "AVX2", short: "AVX2", long:"Advanced Vector Extensions 2", description: [Erweiterung des "x86_64"-Befehlssatzes von Intel (und später auch von AMD), die im Jahr *2013* mit der Haswell-Mikroarchitektur eingeführt wurde. Sie dient der Vektorisierung von Berechnungen, also der gleichzeitigen Verarbeitung mehrerer Datenwerte in einem einzigen Maschinenbefehl.]
  ),
  (
   key: "AVX-512", short: "AVX-512", long:"Advanced Vector Extensions 512", description: [nachfolgende Generation der Vektorerweiterungen im x86-64-Befehlssatz von Intel (und teilweise auch AMD). Sie erweitert die Registerbreite von 256 Bit (AVX2) auf 512 Bit und erlaubt dadurch die gleichzeitige Verarbeitung von bis zu 16 Fließkomma- oder 64 Ganzzahlwerten in einem einzigen Maschinenbefehl.]
  ),
  (
   key: "BE", short: "BE", long: "Big-Endian", description: [Byte-Reihenfolge, bei der das höchstwertige Byte eines Wertes über mehrere Byte an der niedrigsten Speicheradresse abgelegt wird.]
  ),
  (
   key: "BF16", long: "bfloat16", description: [16Bit Gleitkommazahl. Struktur: 1 Bit Vorzeichen, 8 Bit Exponent, 7 Bit Mantisse. Das Format wird daher in modernen Trainingspipelines bevorzugt.]
  ),
  (
   key: "BSI", short: "BSI", long: "Bundesamt für Sicherheit in der Informationstechnik", description: [Deutsche Bundesbehörde, die für Informationssicherheit, IT-Grundschutz sowie die Bewertung, Prävention und Behandlung von IT-Sicherheitsrisiken zuständig ist.]
  ),
  ( 
   key: "CISC", short: "CISC", long: "Complex Instruction Set Computing", description: [Die CPU verfügt über komplexe, mehrstufige Instruktionen, die mehrere Operationen in einem einzigen Befehl ausführen können.]
  ),
  (
   key: "Clang", long:"Clang", description: [Clang ist ein Compiler-Frontend für die Programmiersprachen C, C++, Objective-C und Objective-C++, der für modulare Architektur, gute Tool-Integration und verständliche Fehlermeldungen bekannt ist.]
  ),
  (
   key: "CMS", short: "CMS", long:"Conversational Monitor System", description: [Ein einfaches, interaktives Gastbetriebssystem unter z/VM.]
  ),
  (
   key: "CPU", short: "CPU", long:"Central Processing Unit", description: [Zentrale Verarbeitungseinheit]
  ),
  (
   key: "CP", short: "CP", long:"Control Program", description: [Steuerprogramm des z/VM Betriebssystems.]
  ),
  (
    key: "CSS", short: "CSS", long: "Channel-Subsystem", description: [Steuert alle I/Os unabhängig von der CPU.]
  ),
  (
    key: "CR", short: "CR", long: "Control Register", description: [Steuerregister der IBM Z CPU.]
  ),
  (
   key: "CU", short: "CU", long: "Control Unit", description: [Control Unit: Steuereinheit von Peripheriegeräten.]
  ),
  (
   key: "CUDA", short: "CUDA", long: "Compute Unified Device Architecture", description: [Proprietäre Softwareplattform und API von NVIDIA zur Ausführung von Grafik- und KI Berechnungen auf NVIDIA-GPUs.] 
  ),
  (
   key: "DAT", short: "DAT", long: "Dynamic Address Translation",  description: [IBM spezifische Implementierung der virtuellen Speicherverwaltung.]
  ),
  (
   key: "DMA", short: "DMA", long: "Direct Memory Access",  description: [DMA bezeichnet ein Verfahren, bei dem Peripheriegeräte direkt auf den Hauptspeicher zugreifen können, ohne dass die CPU jeden einzelnen Datenworttransfer steuern muss.]
  ),
  (
   key: "DOS", short: "DOS", long: "Disk Operating System",  description: [Bezeichnung für verschiedene Betriebssysteme; bekannt vor allem als PC-DOS/MS-DOS, wurde der Begriff DOS bei IBM historisch auch für frühere Mainframe-Betriebssysteme verwendet.]
  ),
  (
   key: "DSGVO", short: "DSGVO", long: "Datenschutz-Grundverordnung", description: [EU-Verordnung 2016/679 bildet den zentralen Rechtsrahmen der Europäischen Union für den Schutz personenbezogener Daten.]
  ),
  (
   key: "Endianness", short: "Endianness", long: "Endianness", description: [Bezeichnet die Byte-Reihenfolge, in der Werte über mehrere Bytes (z. B. Integerzahlen oder Adressen) im Speicher abgelegt werden.]
  ),
  (
   key: "ESA/390", short: "ESA/390", long: "Enterprise System Architecture", description: [Vorgängerarchitektur
   der IBM z/Architektur.]
  ),
  (
   key: "ETR", short: "ETR", long:"External Timer Reference", description: [External Timer Reference: Externe Zeitquelle, auch als SYSPLEX-Timer bezeichnet.]
  ),
  (
    key: "FMA3", short: "FMA3", long: "Fused Multiply-Add 3", description: [Fused Multiply-Add 3: Eine Erweiterung der x86-Architektur, die eine Kombination aus Multiplikation und Addition in einem einzigen Befehl ermöglicht.]
  ),
  (
    key: "FPR", short: "FPR", long: "Floating-point Register", description: [Floatingpoint Register: Gleitkommaregister: Register zur Speicherung von Gleitkommazahlen.]
  ),
  (
    key: "FP16", short: "FP16", long: "16-Bit-Gleitkommazahl", description: [16-Bit-Gleitkommazahl: Struktur: 1Bit Vorzeichen, 5 Bit Exponent, 10 Bit Mantisse.]
  ),
  (
    key: "GCC", short: "GCC", long: "GNU C Compiler", description: [Ist eine freie, quelloffene Compiler-Suite, die von der Free Software Foundation (FSF) im Rahmen des GNU-Projekts entwickelt wird. Ursprünglich (1987) war GCC ein reiner C-Compiler; heute unterstützt er eine Vielzahl von Programmiersprachen und Zielplattformen.]
  ),
  (
    key: "GGML", short: "GGML", long: "GGML", description: [Leichtgewichtige C-basierte Tensor-Bibliothek zur effizienten Inferenz quantisierter neuronaler Netze auf CPU-basierten Systemen.]
  ),
  (
   key: "GGUF", short: "GGUF", long:"GGUF", description: [Ein Dateiformat zum Speichern von Inferenzmodellen aus GGML, das die effiziente Speicherung quantisierter Modelle einschließlich Metadaten (z. B. Tokenizer, Kontextgröße, Layer-Typen) in einer einzigen Datei ermöglicht.]
  ),
  (
    key: "GPT", short: "GPT", long: "Generative Pre-trained Transformer", description: [Klasse von Sprachmodellen. GPT-Modelle sind die Grundlage für viele bekannte KI-Anwendungen, wie zum Beispiel ChatGPT (wobei das "Chat" für die spezifische Anwendung als Chatbot steht), und werden für Aufgaben wie das Schreiben von E-Mails, das Verfassen von Code, die Übersetzung von Sprachen und das Beantworten komplexer Fragen eingesetzt.]
  ),
  (
    key: "GPR", short: "GPR", long: "General Purpose Register", description: [Register der IBM Z CPU für die Speicherung von Adressen, Indexen oder sonstigen Werten.]
  ),
  (
    key: "GPU", short:"GPU", long:"Graphics Processing Unit", description: [Im Unterschied zu einer CPU (Central Processing Unit), die für allgemeine, sequenzielle Aufgaben optimiert ist, besteht eine GPU aus hunderten bis tausenden kleiner Recheneinheiten (Shader- oder Compute-Cores), die gleichartige Operationen gleichzeitig auf unterschiedlichen Daten ausführen können.]
  ),
  (
    key: "HBM2", short:"HBM2", long: "High Bandwidth Memory 2", description: [Hochgeschwindigkeitsspeicher (High Bandwidth Memory).]
  ),
  (
    key: "Hyper-V", short:"Hyper-V", long: "Microsoft Hyper-V", description: [Hyper-V ist eine Virtualisierungstechnologie von Microsoft, die es ermöglicht, mehrere virtuelle Maschinen auf einem physischen Host auszuführen.]
  ),
  (
    key: "IBM", short: "IBM", long: "International Business Machines", description: [International Business Machines.]
  ),
  (
    key: "IBM Z", short: "IBM Z", long: "IBM Z-System", description: [Großrechnerserie von IBM auf Basis der z/Architektur, ausgelegt auf Hochverfügbarkeit, Skalierbarkeit und Sicherheit.]
  ),
  (
    key: "IFL", short: "IFL", long: "Integrated Facility LINUX", description: [Für Linux-Systeme entwickelte Charakterisierung einer s390x CPU: Im Gegensatz zu einem CP kann IFL die volle Kapazität eines s390x Prozessors ausschöpfen. CPs sind für klassische Workloads wie z/OS gedacht. Deren Leistungskapazitäten werden durch IBM lizenzrechtlich abgerechnet.]
  ),
  (
    key: "INT4", short: "INT4", long: "4-Bit", description: [ist ein 4-Bit-Quantisierungsformat, das nur 16 Werte repräsentieren kann. Es erzielt extreme Speicherreduktion (¼ des INT16-Speicherverbrauchs und ⅛ von FP32). Moderne Quantisierungsschemata wie Q4_K kompensieren die geringe Präzision durch Block-Skalierung und symmetrisches Clipping, was die Genauigkeit gegenüber naiver INT4-Quantisierung deutlich verbessert.]
  ),
  (
    key: "INT8", short: "INT8", long: "8-Bit", description: [bezeichnet eine ganzzahlige 8-Bit-Darstellung zur Approximation von Modellgewichten oder Aktivierungen. Es können 256 diskrete Werte abgebildet werden. INT8 bietet ein reduziertes Speicherformat bei hoher numerischer Stabilität und wird häufig im Inferenzbetrieb großer Sprachmodelle eingesetzt.]
  ),
  (
    key: "IOMMU", short: "IOMMU", long: "Input/Output Memory Management Unit", description: [Hardwarekomponente, die den direkten Speicherzugriff (DMA) von Peripheriegeräten kontrolliert, indem sie Geräteadressen auf physische Speicheradressen abbildet und dabei Sicherheits- und Isolationseigenschaften bereitstellt.]
  ),
  (
    key: "ISA", short: "ISA", long: "Instruction Set Architecture", description: [Abstrakte Beschreibungs- und Spezifikationsebene einer Prozessorarchitektur, die Befehlssatz, Registermodell, Speicheradressierung, Datenformate und Ausführungsmodelle definiert.]
  ),
  (
    key: "KI", short: "KI", long: "Künstliche Intelligenz", description: [Teilgebiet der Informatik, das sich mit der Entwicklung von Systemen befasst, die kognitive Fähigkeiten wie Lernen, Schlussfolgern, Wahrnehmen oder Sprachverarbeitung automatisiert nachbilden. Maschinelles Lernen stellt dabei einen zentralen methodischen Ansatz dar.]
  ),
  (
    key: "KRITIS", short: "KRITIS", long:"Kritische Infrastrukturen", description: [Kritische Infrastrukturen aus der nationalen Sicherheitsstrategie Österreichs. Bezeichnet Organisationen und Einrichtungen, die für das funktionierende Gemeinwesen unverzichtbar sind – also für die Versorgung, Sicherheit und Stabilität eines Staates.]
  ),
  (
    key: "KVM", short: "KVM", long:"Kernel-based Virtual Machine", description: [ist eine Virtualisierungstechnologie des Linux-Kernels, die Hardware-Virtualisierung
    (Intel VT-x, AMD-V, IBM Z PV) nutzt, um vollständige virtuelle Maschinen auszuführen.]
  ),
  (
    key: "LE", short: "LE", long: "Little-Endian", description: [Byte-Reihenfolge, bei der das niederwertigste Byte eines Wertes über mehrere Byte an der niedrigsten Speicheradresse abgelegt wird.]
  ),
  (
    key: "LinuxONE", short: "LinuxONE", long: "LinuxONE", description: [ist eine Variante der IBM Z Systeme, die z/VM und zLinux unterstützen. Klassische Betriebssysteme von IBM, wie z/OS und z/VSE können auf diesen Systemen nicht betrieben werden.]
  ),
  (
    key: "llama", short: "llama.cpp", long: "llama.cpp", description: [Open-Source-Inferenzbibliothek in C/C++ für LLaMA-kompatible Sprachmodelle.]
  ),
  (
    key: "LLM", short: "LLM", long: "Large Language Model", description: [Large Language Model: Large Language Models (LLMs) sind künstliche neuronale Netze zur Verarbeitung natürlicher Sprache (Natural Language Processing, NLP), die sich durch ihre enorme Modellgröße, kontextuelle Lernfähigkeit und universelle Anwendbarkeit auszeichnen. Im Unterschied zu kleineren Modellen sind LLMs in der Lage, über verschiedene sprachliche Aufgaben hinweg verallgemeinerbare Repräsentationen zu lernen – ohne für jede Aufgabe separat trainiert werden zu müssen.]
  ),
  (
    key: "LSTM", short: "LSTM", long: "Long Short-Term Memory", description: [Spezielle Form eines RNN, die das Verschwinden von Gradienten verhindert und dadurch längere Abhängigkeiten in Sequenzen modellieren kann.]
  ),
  (
    key: "LPAR", short: "LPAR", long: "Logical Partition", description: [IBMs Implementierung der physischen Teilung eines Mainframes in mehrere logische Teile (Partitionen). LPARs sind voneinander völlig unabhängig.]
  ),
  (
    key: "LSB", short: "LSB", long: "Least Significant Bit/Byte", description: [Das Bit/Byte mit dem geringsten numerischen Gewicht innerhalb eines Werts über mehrere Bits oder Bytes. Kann auch für Byte bei mehrbytigen Werten angewandt werden.] 
  ),
  (
    key: "ML", short: "ML", long: "Machine Learning", description: [bezeichnet einen Teilbereich der Künstlichen Intelligenz (KI), der sich mit der Entwicklung von Algorithmen und Modellen befasst, die aus Daten lernen können.]
  ),
  (
    key: "MSB", short: "MSB", long: "Most Significant Bit/Byte", description: [Das Bit mit dem höchsten numerischen Gewicht innerhalb eines Wertes über mehrere Bits/Bytes.] 
  ),
  (
   key: "NLP", short: "NLP", long: "Natural Language Processing",  description: [ist ein Teilgebiet der Künstlichen Intelligenz, das sich mit der automatischen Verarbeitung, Analyse und Generierung natürlicher Sprache befasst.]
  ),
  (
   key: "NIS2", short: "NIS2", long: "Network and Information Security Directive 2",  description: [EU-Richtlinie zur Erhöhung des Cybersicherheitsniveaus kritischer und wichtiger Einrichtungen (EU-Richtlinie 2022/2555).]
  ),
  (
    key: "NPU", short: "NPU", long: "Neural Processing Unit", description: [Spezialisierte Hardwareeinheit zur Beschleunigung neuronaler Netze, insbesondere für Inferenz- und teilweise Trainingsaufgaben.]
  ),
  (
    key: "OSL", short: "Leap", long: "OpenSUSE Leap", description: [ist die Open Source Version von SUSE Enterprise Linux]
  ),
  (
   key: "PoO", short: "PoO", long: "Principles of Operation", description: [Beschreibung, wie die IBM Architektur logisch aufgebaut ist (z.B Prozessorregister, I/O Operationen usw.) Sie beschreiben aber *keine* technischen Umsetzungen.] 
  ),
  (
    key: "POSIX", short: "POSIX", long: "Portable Operating System Interface", description: [IEEE-Standard zur Definition einer einheitlichen Programmierschnittstelle für Unix-artige Betriebssysteme.] 
  ),
  (
    key: "PP", short: "PP", long: "Prompt Processing", description: [Verarbeitung des Eingabeprompts in der Inferenzpipeline.] 
  ),
  (
    key: "PR/SM", short: "PR/SM", long: "Processor Resource/Systems Manager", description: [Hardware-Management-Layer der IBM-Z-Systeme und eine der ältesten Virtualisierungstechnologien.] 
  ),
  (
    key: "PSW", short: "PSW", long: "Program Status Word", description: [128-Bit-Steuerwort, das die gesamte Ausführungssituation eines laufenden Programms beschreibt.] 
  ),
  (
    key: "PTQ", short: "PTQ", long: "Post Training Quantisierung", description: [Quantisierung eines bereits trainierten Modells ohne erneutes Training.] 
  ),
  ( 
    key:"Q4_K_M", short: "Q4_K_M", long: "Q4_K_M", description: [Quantisierungsverfahren: Q4 → 4-Bit-Quantisierung der Gewichte; K → gruppenbasierte Quantisierung („k-quantized blocks“); M → spezielle Blockstruktur („Mixed“ oder „Multi-block format“) mit zusätzlichen Optimierungsparametern.]
  ),
  ( 
    key:"Quantisierung", short: "Quantisierung", long: "Quantisierung", description: [bezeichnet im Kontext von maschinellem Lernen und neuronalen Netzen den Prozess der Reduzierung der Präzision von numerischen Werten, die zur Darstellung von Modellen und Daten verwendet werden. Ziel ist es, den Speicherbedarf und die Rechenleistung zu verringern, ohne die Modellgenauigkeit wesentlich zu beeinträchtigen.]
  ),
  (
    key: "RAM", short: "RAM", long: "Random Access Memory", description: [Beschreib- und lesbarer Hauptspeicher. Informationen des RAM gehen beim Ausschalten verloren.] 
  ),
  (
    key: "RNN", short: "RNN", long: "Recurrent Neural Networks", description: [Verarbeitung von Sequenzdaten mit internem Zustand (Memory) zur Berücksichtigung von früheren Eingaben in späteren Verarbeitungsschritten.] 
  ),
  (
    key: "ROM", short: "ROM", long: "Read Only Memory", description: [Nur Lesespeicher. Information kann nicht geändert werden. Der Inhalt bleibt auch im ausgeschalteten Zustand erhalten.] 
  ),
  (
    key: "RSS", short: "RSS", long: "Resident Set Size", description: [RSS beschreibt die Menge an physischem Hauptspeicher, die einem Prozess aktuell tatsächlich zugeordnet und nicht ausgelagert ist.] 
  ),
  (
    key: "SGD", short: "SGD", long: "Stochastic Gradient Descent", description: [Optimierungsverfahren im maschinellen Lernen – insbesondere beim Training von neuronalen Netzen und damit auch bei Large Language Models (LLMs).  Es dient dazu, die Gewichte (Parameter) eines Modells so anzupassen, dass der Fehler zwischen Vorhersage und tatsächlichem Ergebnis minimiert wird.] 
  ),
  (
    key: "SIMD", short: "SIMD", long: "Single Instruction, Multiple Data", description: [Beschreibt ein Parallelausführungsprinzip, bei dem eine einzige Maschineninstruktion gleichzeitig auf mehrere Datenelemente angewendet wird.] 
  ),
  (
    key: "SLES", short:"SLES", long: "SUSE LINUX Enterprise Server", description: [Enterprise Server Version von SUSE LINUX]
  ),
  (
    key: "S/360", short:"S/360", long:"System/360", description: [IBM System/360 Produktfamilie; ab 1964.]
  ),
  (
    key: "s390x", short:"s390x", long:"System/390 extended", description: [Linux-Architekturbezeichnung für IBM z/Architektur-Systeme, vergleichbar mit x86_64 oder amd64 in der Unix/Linux-Welt.]
  ),
  (
    key: "SMT", short:"SMT", long: "Simultaneous Multithreading", description: [Verfahren zur Steigerung der Prozessorauslastung, bei dem mehrere Hardware-Threads gleichzeitig auf derselben physischen Recheneinheit („Kern“) ausgeführt werden können.]
  ),
  (
    key: "SSE", short:"SSE", long: "Streaming SIMD Extensions", description: [SIMD-Befehlssatzerweiterung der x86-Architektur zur parallelen Verarbeitung mehrerer Datenwerte in einem CPU-Instruktionsschritt (Vektoroperationen); Vorgänger u. a. von AVX/AVX2/AVX-512.]
  ),
  (
    key: "SYSPLEX", short:"SYSPLEX", long: "System Complex", description: [ein Verbund mehrerer IBM Z Systeme, die eng miteinander gekoppelt sind. Aus operativer Sicht werden die Systeme zu einer Einheit zusammengefasst.]
  ),
  (
    key: "TG", short:"TG", long: "Token Generation", description: [Autoregressive Generierung der Ausgabetokens in der Inferenzpipeline.]
  ),
  (
    key: "TOD", short:"TOD", long: "Time Of Day", description: [Systemzeit der TOD-Clock.]
  ),
  (
    key: "TPU", short:"TPU", long: "Tensor Processing Unit", description: [Spezialisierte Hardwarebeschleuniger für maschinelles Lernen, entwickelt von Google.]
  ),
  (
    key: "USS", short: "USS", long: "UNIX System Services", description: [POSIX-konformer Teil des Betriebssystems z/OS von IBM.]
  ),
  (
    key: "VR", short: "VR", long: "Vector Register", description: [IBM Z Vektorregister.]
  ),
  (
    key: "VM", short: "VM", long: "Virtual Machine", description: [Simulierte physische Umgebung auf einem Hostsystem, um Hardware mehreren Benutzern oder Betriebssystemen bereitzustellen.]
  ),
  (
    key: "VSX", short: "VSX", long: "Vector Scalar Facility", description: [Hardware-Erweiterung der IBM POWER für Vektor- und SIMD-Operationen („Single Instruction Multiple Data“).]
  ),
  (
    key: "VXE", short: "VXE", long: "Vector Enhancements Facility", description: [Hardware-Erweiterung der IBM z/Architektur für Vektor- und SIMD-Operationen („Single Instruction Multiple Data“)]
  ),
  (
    key: "VXE2", short: "VXE2", long: "Vector Enhancements Facility 2", description: [Hardware-Erweiterung der IBM z/Architektur für Vektor- und SIMD-Operationen („Single Instruction Multiple Data“)]
  ),
  (
    key: "x86", short: "x86", long: "Intel x86", description: [Intel x86 Mikroprozessorarchitektur.]
  ),
  (
    key: "x86_64", short: "x86_64", long: "Intel x86 64bit", description: [Intel x86 64bit Mikroprozessorarchitektur.]
  ),
  (
    key: "Xen", short: "Xen", long: "Xen-Hypervisor", description: [Der Xen-Hypervisor ist eine Open-Source-Virtualisierungstechnologie, die es ermöglicht, mehrere Betriebssysteme gleichzeitig auf einem physischen Host auszuführen.]
  ),
  (
    key: "z/Architektur", long: "z/Architektur", description: [IBM Systemarchitektur basierend auf den Vorläufern S/360, S/370 und ESA/390.]
  ),
  (
    key: "z/OS", long: "IBM z/OS", description: [Das hauptsächlich verwendete Betriebssystem für Systeme der IBM z/Architektur]
  ),
  (
    key: "z/VM", long: "IBM z/Virtual Machine", description: [Hypervisor von IBM für die Virtualisierung von Rechnerressourcen. Betriebssystem der IBM Z Systeme.]
  ),
  (
    key: "z/VSE", long: "IBM z/Virtual Storage Extended", description: [ist die Weiterentwicklung Betriebssystem DOS/VSE für geringere Anforderungen in Bezug auf Durchsatz und Unternehmensgröße von IBM. z/VSE wird weitgehend als Gastsystem unter z/VM betrieben und stellt die klassische Einstiegskonfiguration in die IBM Z Welt dar.]
  ),
)