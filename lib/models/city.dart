class CitiesService {
  static final List<String> cities = [
    "Adams",
    "Bacarra",
    "Badoc",
    "Bangui",
    "City Of Batac",
    "Burgos",
    "Carasi",
    "Currimao",
    "Dingras",
    "Dumalneg",
    "Banna (Espiritu)",
    "Laoag City (Capital)",
    "Marcos",
    "Nueva Era",
    "Pagudpud",
    "Paoay",
    "Pasuquin",
    "Piddig",
    "Pinili",
    "San Nicolas",
    "Sarrat",
    "Solsona",
    "Vintar",
    "Alilem",
    "Banayoyo",
    "Bantay",
    "Burgos",
    "Cabugao",
    "City Of Candon",
    "Caoayan",
    "Cervantes",
    "Galimuyod",
    "Gregorio Del Pilar (Concepcion)",
    "Lidlidda",
    "Magsingal",
    "Nagbukel",
    "Narvacan",
    "Quirino (Angkaki)",
    "Salcedo (Baugen)",
    "San Emilio",
    "San Esteban",
    "San Ildefonso",
    "San Juan (Lapog)",
    "San Vicente",
    "Santa",
    "Santa Catalina",
    "Santa Cruz",
    "Santa Lucia",
    "Santa Maria",
    "Santiago",
    "Santo Domingo",
    "Sigay",
    "Sinait",
    "Sugpon",
    "Suyo",
    "Tagudin",
    "City Of Vigan (Capital)",
    "Agoo",
    "Aringay",
    "Bacnotan",
    "Bagulin",
    "Balaoan",
    "Bangar",
    "Bauang",
    "Burgos",
    "Caba",
    "Luna",
    "Naguilian",
    "Pugo",
    "Rosario",
    "City Of San Fernando (Capital)",
    "San Gabriel",
    "San Juan",
    "Santo Tomas",
    "Santol",
    "Sudipen",
    "Tubao",
    "Agno",
    "Aguilar",
    "City Of Alaminos",
    "Alcala",
    "Anda",
    "Asingan",
    "Balungao",
    "Bani",
    "Basista",
    "Bautista",
    "Bayambang",
    "Binalonan",
    "Binmaley",
    "Bolinao",
    "Bugallon",
    "Burgos",
    "Calasiao",
    "Dagupan City",
    "Dasol",
    "Infanta",
    "Labrador",
    "Lingayen (Capital)",
    "Mabini",
    "Malasiqui",
    "Manaoag",
    "Mangaldan",
    "Mangatarem",
    "Mapandan",
    "Natividad",
    "Pozorrubio",
    "Rosales",
    "San Carlos City",
    "San Fabian",
    "San Jacinto",
    "San Manuel",
    "San Nicolas",
    "San Quintin",
    "Santa Barbara",
    "Santa Maria",
    "Santo Tomas",
    "Sison",
    "Sual",
    "Tayug",
    "Umingan",
    "Urbiztondo",
    "City Of Urdaneta",
    "Villasis",
    "Laoac",
    "Basco (Capital)",
    "Itbayat",
    "Ivana",
    "Mahatao",
    "Sabtang",
    "Uyugan",
    "Abulug",
    "Alcala",
    "Allacapan",
    "Amulung",
    "Aparri",
    "Baggao",
    "Ballesteros",
    "Buguey",
    "Calayan",
    "Camalaniugan",
    "Claveria",
    "Enrile",
    "Gattaran",
    "Gonzaga",
    "Iguig",
    "Lal-lo",
    "Lasam",
    "Pamplona",
    "Peñablanca",
    "Piat",
    "Rizal",
    "Sanchez-mira",
    "Santa Ana",
    "Santa Praxedes",
    "Santa Teresita",
    "Santo Niño (Faire)",
    "Solana",
    "Tuao",
    "Tuguegarao City (Capital)",
    "Alicia",
    "Angadanan",
    "Aurora",
    "Benito Soliven",
    "Burgos",
    "Cabagan",
    "Cabatuan",
    "City Of Cauayan",
    "Cordon",
    "Dinapigue",
    "Divilacan",
    "Echague",
    "Gamu",
    "Ilagan City (Capital)",
    "Jones",
    "Luna",
    "Maconacon",
    "Delfin Albano (Magsaysay)",
    "Mallig",
    "Naguilian",
    "Palanan",
    "Quezon",
    "Quirino",
    "Ramon",
    "Reina Mercedes",
    "Roxas",
    "San Agustin",
    "San Guillermo",
    "San Isidro",
    "San Manuel",
    "San Mariano",
    "San Mateo",
    "San Pablo",
    "Santa Maria",
    "City Of Santiago",
    "Santo Tomas",
    "Tumauini",
    "Ambaguio",
    "Aritao",
    "Bagabag",
    "Bambang",
    "Bayombong (Capital)",
    "Diadi",
    "Dupax Del Norte",
    "Dupax Del Sur",
    "Kasibu",
    "Kayapa",
    "Quezon",
    "Santa Fe",
    "Solano",
    "Villaverde",
    "Alfonso Castaneda",
    "Aglipay",
    "Cabarroguis (Capital)",
    "Diffun",
    "Maddela",
    "Saguday",
    "Nagtipunan",
    "Abucay",
    "Bagac",
    "City Of Balanga (Capital)",
    "Dinalupihan",
    "Hermosa",
    "Limay",
    "Mariveles",
    "Morong",
    "Orani",
    "Orion",
    "Pilar",
    "Samal",
    "Angat",
    "Balagtas (Bigaa)",
    "Baliuag",
    "Bocaue",
    "Bulacan",
    "Bustos",
    "Calumpit",
    "Guiguinto",
    "Hagonoy",
    "City Of Malolos (Capital)",
    "Marilao",
    "City Of Meycauayan",
    "Norzagaray",
    "Obando",
    "Pandi",
    "Paombong",
    "Plaridel",
    "Pulilan",
    "San Ildefonso",
    "City Of San Jose Del Monte",
    "San Miguel",
    "San Rafael",
    "Santa Maria",
    "Doña Remedios Trinidad",
    "Aliaga",
    "Bongabon",
    "Cabanatuan City",
    "Cabiao",
    "Carranglan",
    "Cuyapo",
    "Gabaldon (Bitulok & Sabani)",
    "City Of Gapan",
    "General Mamerto Natividad",
    "General Tinio (Papaya)",
    "Guimba",
    "Jaen",
    "Laur",
    "Licab",
    "Llanera",
    "Lupao",
    "Science City Of Muñoz",
    "Nampicuan",
    "Palayan City (Capital)",
    "Pantabangan",
    "Peñaranda",
    "Quezon",
    "Rizal",
    "San Antonio",
    "San Isidro",
    "San Jose City",
    "San Leonardo",
    "Santa Rosa",
    "Santo Domingo",
    "Talavera",
    "Talugtug",
    "Zaragoza",
    "Angeles City",
    "Apalit",
    "Arayat",
    "Bacolor",
    "Candaba",
    "Floridablanca",
    "Guagua",
    "Lubao",
    "Mabalacat City",
    "Macabebe",
    "Magalang",
    "Masantol",
    "Mexico",
    "Minalin",
    "Porac",
    "City Of San Fernando (Capital)",
    "San Luis",
    "San Simon",
    "Santa Ana",
    "Santa Rita",
    "Santo Tomas",
    "Sasmuan (Sexmoan)",
    "Anao",
    "Bamban",
    "Camiling",
    "Capas",
    "Concepcion",
    "Gerona",
    "La Paz",
    "Mayantoc",
    "Moncada",
    "Paniqui",
    "Pura",
    "Ramos",
    "San Clemente",
    "San Manuel",
    "Santa Ignacia",
    "City Of Tarlac (Capital)",
    "Victoria",
    "San Jose",
    "Botolan",
    "Cabangan",
    "Candelaria",
    "Castillejos",
    "Iba (Capital)",
    "Masinloc",
    "Olongapo City",
    "Palauig",
    "San Antonio",
    "San Felipe",
    "San Marcelino",
    "San Narciso",
    "Santa Cruz",
    "Subic",
    "Baler (Capital)",
    "Casiguran",
    "Dilasag",
    "Dinalungan",
    "Dingalan",
    "Dipaculao",
    "Maria Aurora",
    "San Luis",
    "Agoncillo",
    "Alitagtag",
    "Balayan",
    "Balete",
    "Batangas City (Capital)",
    "Bauan",
    "Calaca",
    "Calatagan",
    "Cuenca",
    "Ibaan",
    "Laurel",
    "Lemery",
    "Lian",
    "Lipa City",
    "Lobo",
    "Mabini",
    "Malvar",
    "Mataasnakahoy",
    "Nasugbu",
    "Padre Garcia",
    "Rosario",
    "San Jose",
    "San Juan",
    "San Luis",
    "San Nicolas",
    "San Pascual",
    "Santa Teresita",
    "Santo Tomas",
    "Taal",
    "Talisay",
    "City Of Tanauan",
    "Taysan",
    "Tingloy",
    "Tuy",
    "Alfonso",
    "Amadeo",
    "Bacoor City",
    "Carmona",
    "Cavite City",
    "City Of Dasmariñas",
    "General Emilio Aguinaldo",
    "General Trias",
    "Imus City",
    "Indang",
    "Kawit",
    "Magallanes",
    "Maragondon",
    "Mendez (Mendez-nuñez)",
    "Naic",
    "Noveleta",
    "Rosario",
    "Silang",
    "Tagaytay City",
    "Tanza",
    "Ternate",
    "Trece Martires City (Capital)",
    "Gen. Mariano Alvarez",
    "Alaminos",
    "Bay",
    "City Of Biñan",
    "Cabuyao City",
    "City Of Calamba",
    "Calauan",
    "Cavinti",
    "Famy",
    "Kalayaan",
    "Liliw",
    "Los Baños",
    "Luisiana",
    "Lumban",
    "Mabitac",
    "Magdalena",
    "Majayjay",
    "Nagcarlan",
    "Paete",
    "Pagsanjan",
    "Pakil",
    "Pangil",
    "Pila",
    "Rizal",
    "San Pablo City",
    "City Of San Pedro",
    "Santa Cruz (Capital)",
    "Santa Maria",
    "City Of Santa Rosa",
    "Siniloan",
    "Victoria",
    "Agdangan",
    "Alabat",
    "Atimonan",
    "Buenavista",
    "Burdeos",
    "Calauag",
    "Candelaria",
    "Catanauan",
    "Dolores",
    "General Luna",
    "General Nakar",
    "Guinayangan",
    "Gumaca",
    "Infanta",
    "Jomalig",
    "Lopez",
    "Lucban",
    "Lucena City (Capital)",
    "Macalelon",
    "Mauban",
    "Mulanay",
    "Padre Burgos",
    "Pagbilao",
    "Panukulan",
    "Patnanungan",
    "Perez",
    "Pitogo",
    "Plaridel",
    "Polillo",
    "Quezon",
    "Real",
    "Sampaloc",
    "San Andres",
    "San Antonio",
    "San Francisco (Aurora)",
    "San Narciso",
    "Sariaya",
    "Tagkawayan",
    "City Of Tayabas",
    "Tiaong",
    "Unisan",
    "Angono",
    "City Of Antipolo",
    "Baras",
    "Binangonan",
    "Cainta",
    "Cardona",
    "Jala-jala",
    "Rodriguez (Montalban)",
    "Morong",
    "Pililla",
    "San Mateo",
    "Tanay",
    "Taytay",
    "Teresa",
    "Boac (Capital)",
    "Buenavista",
    "Gasan",
    "Mogpog",
    "Santa Cruz",
    "Torrijos",
    "Abra De Ilog",
    "Calintaan",
    "Looc",
    "Lubang",
    "Magsaysay",
    "Mamburao (Capital)",
    "Paluan",
    "Rizal",
    "Sablayan",
    "San Jose",
    "Santa Cruz",
    "Baco",
    "Bansud",
    "Bongabong",
    "Bulalacao (San Pedro)",
    "City Of Calapan (Capital)",
    "Gloria",
    "Mansalay",
    "Naujan",
    "Pinamalayan",
    "Pola",
    "Puerto Galera",
    "Roxas",
    "San Teodoro",
    "Socorro",
    "Victoria",
    "Aborlan",
    "Agutaya",
    "Araceli",
    "Balabac",
    "Bataraza",
    "Brooke's Point",
    "Busuanga",
    "Cagayancillo",
    "Coron",
    "Cuyo",
    "Dumaran",
    "El Nido (Bacuit)",
    "Linapacan",
    "Magsaysay",
    "Narra",
    "Puerto Princesa City (Capital)",
    "Quezon",
    "Roxas",
    "San Vicente",
    "Taytay",
    "Kalayaan",
    "Culion",
    "Rizal (Marcos)",
    "Sofronio Española",
    "Alcantara",
    "Banton",
    "Cajidiocan",
    "Calatrava",
    "Concepcion",
    "Corcuera",
    "Looc",
    "Magdiwang",
    "Odiongan",
    "Romblon (Capital)",
    "San Agustin",
    "San Andres",
    "San Fernando",
    "San Jose",
    "Santa Fe",
    "Ferrol",
    "Santa Maria (Imelda)",
    "Bacacay",
    "Camalig",
    "Daraga (Locsin)",
    "Guinobatan",
    "Jovellar",
    "Legazpi City (Capital)",
    "Libon",
    "City Of Ligao",
    "Malilipot",
    "Malinao",
    "Manito",
    "Oas",
    "Pio Duran",
    "Polangui",
    "Rapu-rapu",
    "Santo Domingo (Libog)",
    "City Of Tabaco",
    "Tiwi",
    "Basud",
    "Capalonga",
    "Daet (Capital)",
    "San Lorenzo Ruiz (Imelda)",
    "Jose Panganiban",
    "Labo",
    "Mercedes",
    "Paracale",
    "San Vicente",
    "Santa Elena",
    "Talisay",
    "Vinzons",
    "Baao",
    "Balatan",
    "Bato",
    "Bombon",
    "Buhi",
    "Bula",
    "Cabusao",
    "Calabanga",
    "Camaligan",
    "Canaman",
    "Caramoan",
    "Del Gallego",
    "Gainza",
    "Garchitorena",
    "Goa",
    "Iriga City",
    "Lagonoy",
    "Libmanan",
    "Lupi",
    "Magarao",
    "Milaor",
    "Minalabac",
    "Nabua",
    "Naga City",
    "Ocampo",
    "Pamplona",
    "Pasacao",
    "Pili (Capital)",
    "Presentacion (Parubcan)",
    "Ragay",
    "Sagñay",
    "San Fernando",
    "San Jose",
    "Sipocot",
    "Siruma",
    "Tigaon",
    "Tinambac",
    "Bagamanoc",
    "Baras",
    "Bato",
    "Caramoran",
    "Gigmoto",
    "Pandan",
    "Panganiban",
    "San Andres",
    "San Miguel",
    "Viga",
    "Virac",
    "Aroroy",
    "Baleno",
    "Balud",
    "Batuan",
    "Cataingan",
    "Cawayan",
    "Claveria",
    "Dimasalang",
    "Esperanza",
    "Mandaon",
    "City Of Masbate (Capital)",
    "Milagros",
    "Mobo",
    "Monreal",
    "Palanas",
    "Pio V. Corpuz (Limbuhan)",
    "Placer",
    "San Fernando",
    "San Jacinto",
    "San Pascual",
    "Uson",
    "Barcelona",
    "Bulan",
    "Bulusan",
    "Casiguran",
    "Castilla",
    "Donsol",
    "Gubat",
    "Irosin",
    "Juban",
    "Magallanes",
    "Matnog",
    "Pilar",
    "Prieto Diaz",
    "Santa Magdalena",
    "City Of Sorsogon (Capital)",
    "Altavas",
    "Balete",
    "Banga",
    "Batan",
    "Buruanga",
    "Ibajay",
    "Kalibo (Capital)",
    "Lezo",
    "Libacao",
    "Madalag",
    "Makato",
    "Malay",
    "Malinao",
    "Nabas",
    "New Washington",
    "Numancia",
    "Tangalan",
    "Anini-y",
    "Barbaza",
    "Belison",
    "Bugasong",
    "Caluya",
    "Culasi",
    "Tobias Fornier (Dao)",
    "Hamtic",
    "Laua-an",
    "Libertad",
    "Pandan",
    "Patnongon",
    "San Jose (Capital)",
    "San Remigio",
    "Sebaste",
    "Sibalom",
    "Tibiao",
    "Valderrama",
    "Cuartero",
    "Dao",
    "Dumalag",
    "Dumarao",
    "Ivisan",
    "Jamindan",
    "Ma-ayon",
    "Mambusao",
    "Panay",
    "Panitan",
    "Pilar",
    "Pontevedra",
    "President Roxas",
    "Roxas City (Capital)",
    "Sapi-an",
    "Sigma",
    "Tapaz",
    "Ajuy",
    "Alimodian",
    "Anilao",
    "Badiangan",
    "Balasan",
    "Banate",
    "Barotac Nuevo",
    "Barotac Viejo",
    "Batad",
    "Bingawan",
    "Cabatuan",
    "Calinog",
    "Carles",
    "Concepcion",
    "Dingle",
    "Dueñas",
    "Dumangas",
    "Estancia",
    "Guimbal",
    "Igbaras",
    "Iloilo City (Capital)",
    "Janiuay",
    "Lambunao",
    "Leganes",
    "Lemery",
    "Leon",
    "Maasin",
    "Miagao",
    "Mina",
    "New Lucena",
    "Oton",
    "City Of Passi",
    "Pavia",
    "Pototan",
    "San Dionisio",
    "San Enrique",
    "San Joaquin",
    "San Miguel",
    "San Rafael",
    "Santa Barbara",
    "Sara",
    "Tigbauan",
    "Tubungan",
    "Zarraga",
    "Bacolod City (Capital)",
    "Bago City",
    "Binalbagan",
    "Cadiz City",
    "Calatrava",
    "Candoni",
    "Cauayan",
    "Enrique B. Magalona (Saravia)",
    "City Of Escalante",
    "City Of Himamaylan",
    "Hinigaran",
    "Hinoba-an (Asia)",
    "Ilog",
    "Isabela",
    "City Of Kabankalan",
    "La Carlota City",
    "La Castellana",
    "Manapla",
    "Moises Padilla (Magallon)",
    "Murcia",
    "Pontevedra",
    "Pulupandan",
    "Sagay City",
    "San Carlos City",
    "San Enrique",
    "Silay City",
    "City Of Sipalay",
    "City Of Talisay",
    "Toboso",
    "Valladolid",
    "City Of Victorias",
    "Salvador Benedicto",
    "Buenavista",
    "Jordan (Capital)",
    "Nueva Valencia",
    "San Lorenzo",
    "Sibunag",
    "Alburquerque",
    "Alicia",
    "Anda",
    "Antequera",
    "Baclayon",
    "Balilihan",
    "Batuan",
    "Bilar",
    "Buenavista",
    "Calape",
    "Candijay",
    "Carmen",
    "Catigbian",
    "Clarin",
    "Corella",
    "Cortes",
    "Dagohoy",
    "Danao",
    "Dauis",
    "Dimiao",
    "Duero",
    "Garcia Hernandez",
    "Guindulman",
    "Inabanga",
    "Jagna",
    "Jetafe",
    "Lila",
    "Loay",
    "Loboc",
    "Loon",
    "Mabini",
    "Maribojoc",
    "Panglao",
    "Pilar",
    "Pres. Carlos P. Garcia (Pitogo)",
    "Sagbayan (Borja)",
    "San Isidro",
    "San Miguel",
    "Sevilla",
    "Sierra Bullones",
    "Sikatuna",
    "Tagbilaran City (Capital)",
    "Talibon",
    "Trinidad",
    "Tubigon",
    "Ubay",
    "Valencia",
    "Bien Unido",
    "Alcantara",
    "Alcoy",
    "Alegria",
    "Aloguinsan",
    "Argao",
    "Asturias",
    "Badian",
    "Balamban",
    "Bantayan",
    "Barili",
    "City Of Bogo",
    "Boljoon",
    "Borbon",
    "City Of Carcar",
    "Carmen",
    "Catmon",
    "Cebu City (Capital)",
    "Compostela",
    "Consolacion",
    "Cordova",
    "Daanbantayan",
    "Dalaguete",
    "Danao City",
    "Dumanjug",
    "Ginatilan",
    "Lapu-lapu City (Opon)",
    "Liloan",
    "Madridejos",
    "Malabuyoc",
    "Mandaue City",
    "Medellin",
    "Minglanilla",
    "Moalboal",
    "City Of Naga",
    "Oslob",
    "Pilar",
    "Pinamungahan",
    "Poro",
    "Ronda",
    "Samboan",
    "San Fernando",
    "San Francisco",
    "San Remigio",
    "Santa Fe",
    "Santander",
    "Sibonga",
    "Sogod",
    "Tabogon",
    "Tabuelan",
    "City Of Talisay",
    "Toledo City",
    "Tuburan",
    "Tudela",
    "Amlan (Ayuquitan)",
    "Ayungon",
    "Bacong",
    "Bais City",
    "Basay",
    "City Of Bayawan (Tulong)",
    "Bindoy (Payabon)",
    "Canlaon City",
    "Dauin",
    "Dumaguete City (Capital)",
    "City Of Guihulngan",
    "Jimalalud",
    "La Libertad",
    "Mabinay",
    "Manjuyod",
    "Pamplona",
    "San Jose",
    "Santa Catalina",
    "Siaton",
    "Sibulan",
    "City Of Tanjay",
    "Tayasan",
    "Valencia (Luzurriaga)",
    "Vallehermoso",
    "Zamboanguita",
    "Enrique Villanueva",
    "Larena",
    "Lazi",
    "Maria",
    "San Juan",
    "Siquijor (Capital)",
    "Arteche",
    "Balangiga",
    "Balangkayan",
    "City Of Borongan (Capital)",
    "Can-avid",
    "Dolores",
    "General Macarthur",
    "Giporlos",
    "Guiuan",
    "Hernani",
    "Jipapad",
    "Lawaan",
    "Llorente",
    "Maslog",
    "Maydolong",
    "Mercedes",
    "Oras",
    "Quinapondan",
    "Salcedo",
    "San Julian",
    "San Policarpo",
    "Sulat",
    "Taft",
    "Abuyog",
    "Alangalang",
    "Albuera",
    "Babatngon",
    "Barugo",
    "Bato",
    "City Of Baybay",
    "Burauen",
    "Calubian",
    "Capoocan",
    "Carigara",
    "Dagami",
    "Dulag",
    "Hilongos",
    "Hindang",
    "Inopacan",
    "Isabel",
    "Jaro",
    "Javier (Bugho)",
    "Julita",
    "Kananga",
    "La Paz",
    "Leyte",
    "Macarthur",
    "Mahaplag",
    "Matag-ob",
    "Matalom",
    "Mayorga",
    "Merida",
    "Ormoc City",
    "Palo",
    "Palompon",
    "Pastrana",
    "San Isidro",
    "San Miguel",
    "Santa Fe",
    "Tabango",
    "Tabontabon",
    "Tacloban City (Capital)",
    "Tanauan",
    "Tolosa",
    "Tunga",
    "Villaba",
    "Allen",
    "Biri",
    "Bobon",
    "Capul",
    "Catarman (Capital)",
    "Catubig",
    "Gamay",
    "Laoang",
    "Lapinig",
    "Las Navas",
    "Lavezares",
    "Mapanas",
    "Mondragon",
    "Palapag",
    "Pambujan",
    "Rosario",
    "San Antonio",
    "San Isidro",
    "San Jose",
    "San Roque",
    "San Vicente",
    "Silvino Lobos",
    "Victoria",
    "Lope De Vega",
    "Almagro",
    "Basey",
    "Calbayog City",
    "Calbiga",
    "City Of Catbalogan (Capital)",
    "Daram",
    "Gandara",
    "Hinabangan",
    "Jiabong",
    "Marabut",
    "Matuguinao",
    "Motiong",
    "Pinabacdao",
    "San Jose De Buan",
    "San Sebastian",
    "Santa Margarita",
    "Santa Rita",
    "Santo Niño",
    "Talalora",
    "Tarangnan",
    "Villareal",
    "Paranas (Wright)",
    "Zumarraga",
    "Tagapul-an",
    "San Jorge",
    "Pagsanghan",
    "Anahawan",
    "Bontoc",
    "Hinunangan",
    "Hinundayan",
    "Libagon",
    "Liloan",
    "City Of Maasin (Capital)",
    "Macrohon",
    "Malitbog",
    "Padre Burgos",
    "Pintuyan",
    "Saint Bernard",
    "San Francisco",
    "San Juan (Cabalian)",
    "San Ricardo",
    "Silago",
    "Sogod",
    "Tomas Oppus",
    "Limasawa",
    "Almeria",
    "Biliran",
    "Cabucgayan",
    "Caibiran",
    "Culaba",
    "Kawayan",
    "Maripipi",
    "Naval (Capital)",
    "Dapitan City",
    "Dipolog City (Capital)",
    "Katipunan",
    "La Libertad",
    "Labason",
    "Liloy",
    "Manukan",
    "Mutia",
    "Piñan (New Piñan)",
    "Polanco",
    "Pres. Manuel A. Roxas",
    "Rizal",
    "Salug",
    "Sergio Osmeña Sr.",
    "Siayan",
    "Sibuco",
    "Sibutad",
    "Sindangan",
    "Siocon",
    "Sirawai",
    "Tampilisan",
    "Jose Dalman (Ponot)",
    "Gutalac",
    "Baliguian",
    "Godod",
    "Bacungan (Leon T. Postigo)",
    "Kalawit",
    "Aurora",
    "Bayog",
    "Dimataling",
    "Dinas",
    "Dumalinao",
    "Dumingag",
    "Kumalarang",
    "Labangan",
    "Lapuyan",
    "Mahayag",
    "Margosatubig",
    "Midsalip",
    "Molave",
    "Pagadian City (Capital)",
    "Ramon Magsaysay (Liargo)",
    "San Miguel",
    "San Pablo",
    "Tabina",
    "Tambulig",
    "Tukuran",
    "Zamboanga City",
    "Lakewood",
    "Josefina",
    "Pitogo",
    "Sominot (Don Mariano Marcos)",
    "Vincenzo A. Sagun",
    "Guipos",
    "Tigbao",
    "Alicia",
    "Buug",
    "Diplahan",
    "Imelda",
    "Ipil (Capital)",
    "Kabasalan",
    "Mabuhay",
    "Malangas",
    "Naga",
    "Olutanga",
    "Payao",
    "Roseller Lim",
    "Siay",
    "Talusan",
    "Titay",
    "Tungawan",
    "City Of Isabela",
    "Baungon",
    "Damulog",
    "Dangcagan",
    "Don Carlos",
    "Impasug-ong",
    "Kadingilan",
    "Kalilangan",
    "Kibawe",
    "Kitaotao",
    "Lantapan",
    "Libona",
    "City Of Malaybalay (Capital)",
    "Malitbog",
    "Manolo Fortich",
    "Maramag",
    "Pangantucan",
    "Quezon",
    "San Fernando",
    "Sumilao",
    "Talakag",
    "City Of Valencia",
    "Cabanglasan",
    "Catarman",
    "Guinsiliban",
    "Mahinog",
    "Mambajao (Capital)",
    "Sagay",
    "Bacolod",
    "Baloi",
    "Baroy",
    "Iligan City",
    "Kapatagan",
    "Sultan Naga Dimaporo (Karomatan)",
    "Kauswagan",
    "Kolambugan",
    "Lala",
    "Linamon",
    "Magsaysay",
    "Maigo",
    "Matungao",
    "Munai",
    "Nunungan",
    "Pantao Ragat",
    "Poona Piagapo",
    "Salvador",
    "Sapad",
    "Tagoloan",
    "Tangcal",
    "Tubod (Capital)",
    "Pantar",
    "Aloran",
    "Baliangao",
    "Bonifacio",
    "Calamba",
    "Clarin",
    "Concepcion",
    "Jimenez",
    "Lopez Jaena",
    "Oroquieta City (Capital)",
    "Ozamis City",
    "Panaon",
    "Plaridel",
    "Sapang Dalaga",
    "Sinacaban",
    "Tangub City",
    "Tudela",
    "Don Victoriano Chiongbian  (Don Mariano Marcos)",
    "Alubijid",
    "Balingasag",
    "Balingoan",
    "Binuangan",
    "Cagayan De Oro City (Capital)",
    "Claveria",
    "City Of El Salvador",
    "Gingoog City",
    "Gitagum",
    "Initao",
    "Jasaan",
    "Kinoguitan",
    "Lagonglong",
    "Laguindingan",
    "Libertad",
    "Lugait",
    "Magsaysay (Linugos)",
    "Manticao",
    "Medina",
    "Naawan",
    "Opol",
    "Salay",
    "Sugbongcogon",
    "Tagoloan",
    "Talisayan",
    "Villanueva",
    "Asuncion (Saug)",
    "Carmen",
    "Kapalong",
    "New Corella",
    "City Of Panabo",
    "Island Garden City Of Samal",
    "Santo Tomas",
    "City Of Tagum (Capital)",
    "Talaingod",
    "Braulio E. Dujali",
    "San Isidro",
    "Bansalan",
    "Davao City",
    "City Of Digos (Capital)",
    "Hagonoy",
    "Kiblawan",
    "Magsaysay",
    "Malalag",
    "Matanao",
    "Padada",
    "Santa Cruz",
    "Sulop",
    "Baganga",
    "Banaybanay",
    "Boston",
    "Caraga",
    "Cateel",
    "Governor Generoso",
    "Lupon",
    "Manay",
    "City Of Mati (Capital)",
    "San Isidro",
    "Tarragona",
    "Compostela",
    "Laak (San Vicente)",
    "Mabini (Doña Alicia)",
    "Maco",
    "Maragusan (San Mariano)",
    "Mawab",
    "Monkayo",
    "Montevista",
    "Nabunturan (Capital)",
    "New Bataan",
    "Pantukan",
    "Don Marcelino",
    "Jose Abad Santos (Trinidad)",
    "Malita",
    "Santa Maria",
    "Sarangani",
    "Alamada",
    "Carmen",
    "Kabacan",
    "City Of Kidapawan (Capital)",
    "Libungan",
    "Magpet",
    "Makilala",
    "Matalam",
    "Midsayap",
    "M'lang",
    "Pigkawayan",
    "Pikit",
    "President Roxas",
    "Tulunan",
    "Antipas",
    "Banisilan",
    "Aleosan",
    "Arakan",
    "Banga",
    "General Santos City (Dadiangas)",
    "City Of Koronadal (Capital)",
    "Norala",
    "Polomolok",
    "Surallah",
    "Tampakan",
    "Tantangan",
    "T'boli",
    "Tupi",
    "Santo Niño",
    "Lake Sebu",
    "Bagumbayan",
    "Columbio",
    "Esperanza",
    "Isulan (Capital)",
    "Kalamansig",
    "Lebak",
    "Lutayan",
    "Lambayong (Mariano Marcos)",
    "Palimbang",
    "President Quirino",
    "City Of Tacurong",
    "Sen. Ninoy Aquino",
    "Alabel (Capital)",
    "Glan",
    "Kiamba",
    "Maasim",
    "Maitum",
    "Malapatan",
    "Malungon",
    "Cotabato City",
    "Tondo I / Ii",
    "Binondo",
    "Quiapo",
    "San Nicolas",
    "Santa Cruz",
    "Sampaloc",
    "San Miguel",
    "Ermita",
    "Intramuros",
    "Malate",
    "Paco",
    "Pandacan",
    "Port Area",
    "Santa Ana",
    "City Of Mandaluyong",
    "City Of Marikina",
    "City Of Pasig",
    "Quezon City",
    "City Of San Juan",
    "Caloocan City",
    "City Of Malabon",
    "City Of Navotas",
    "City Of Valenzuela",
    "City Of Las Piñas",
    "City Of Makati",
    "City Of Muntinlupa",
    "City Of Parañaque",
    "Pasay City",
    "Pateros",
    "Taguig City",
    "Bangued (Capital)",
    "Boliney",
    "Bucay",
    "Bucloc",
    "Daguioman",
    "Danglas",
    "Dolores",
    "La Paz",
    "Lacub",
    "Lagangilang",
    "Lagayan",
    "Langiden",
    "Licuan-baay (Licuan)",
    "Luba",
    "Malibcong",
    "Manabo",
    "Peñarrubia",
    "Pidigan",
    "Pilar",
    "Sallapadan",
    "San Isidro",
    "San Juan",
    "San Quintin",
    "Tayum",
    "Tineg",
    "Tubo",
    "Villaviciosa",
    "Atok",
    "Baguio City",
    "Bakun",
    "Bokod",
    "Buguias",
    "Itogon",
    "Kabayan",
    "Kapangan",
    "Kibungan",
    "La Trinidad (Capital)",
    "Mankayan",
    "Sablan",
    "Tuba",
    "Tublay",
    "Banaue",
    "Hungduan",
    "Kiangan",
    "Lagawe (Capital)",
    "Lamut",
    "Mayoyao",
    "Alfonso Lista (Potia)",
    "Aguinaldo",
    "Hingyon",
    "Tinoc",
    "Asipulo",
    "Balbalan",
    "Lubuagan",
    "Pasil",
    "Pinukpuk",
    "Rizal (Liwan)",
    "City Of Tabuk (Capital)",
    "Tanudan",
    "Tinglayan",
    "Barlig",
    "Bauko",
    "Besao",
    "Bontoc (Capital)",
    "Natonin",
    "Paracelis",
    "Sabangan",
    "Sadanga",
    "Sagada",
    "Tadian",
    "Calanasan (Bayag)",
    "Conner",
    "Flora",
    "Kabugao (Capital)",
    "Luna",
    "Pudtol",
    "Santa Marcela",
    "City Of Lamitan",
    "Lantawan",
    "Maluso",
    "Sumisip",
    "Tipo-tipo",
    "Tuburan",
    "Akbar",
    "Al-barka",
    "Hadji Mohammad Ajul",
    "Ungkaya Pukan",
    "Hadji Muhtamad",
    "Tabuan-lasa",
    "Bacolod-kalawi (Bacolod Grande)",
    "Balabagan",
    "Balindong (Watu)",
    "Bayang",
    "Binidayan",
    "Bubong",
    "Butig",
    "Ganassi",
    "Kapai",
    "Lumba-bayabao (Maguing)",
    "Lumbatan",
    "Madalum",
    "Madamba",
    "Malabang",
    "Marantao",
    "Marawi City (Capital)",
    "Masiu",
    "Mulondo",
    "Pagayawan (Tatarikan)",
    "Piagapo",
    "Poona Bayabao (Gata)",
    "Pualas",
    "Ditsaan-ramain",
    "Saguiaran",
    "Tamparan",
    "Taraka",
    "Tubaran",
    "Tugaya",
    "Wao",
    "Marogong",
    "Calanogas",
    "Buadiposo-buntong",
    "Maguing",
    "Picong (Sultan Gumander)",
    "Lumbayanague",
    "Bumbaran",
    "Tagoloan Ii",
    "Kapatagan",
    "Sultan Dumalondong",
    "Lumbaca-unayan",
    "Ampatuan",
    "Buldon",
    "Buluan",
    "Datu Paglas",
    "Datu Piang",
    "Datu Odin Sinsuat (Dinaig)",
    "Shariff Aguak (Maganoy) (Capital)",
    "Matanog",
    "Pagalungan",
    "Parang",
    "Sultan Kudarat (Nuling)",
    "Sultan Sa Barongis (Lambayong)",
    "Kabuntalan (Tumbao)",
    "Upi",
    "Talayan",
    "South Upi",
    "Barira",
    "Gen. S. K. Pendatun",
    "Mamasapano",
    "Talitay",
    "Pagagawan",
    "Paglat",
    "Sultan Mastura",
    "Guindulungan",
    "Datu Saudi-ampatuan",
    "Datu Unsay",
    "Datu Abdullah Sangki",
    "Rajah Buayan",
    "Datu Blah T. Sinsuat",
    "Datu Anggal Midtimbang",
    "Mangudadatu",
    "Pandag",
    "Northern Kabuntalan",
    "Datu Hoffer Ampatuan",
    "Datu Salibo",
    "Shariff Saydona Mustapha",
    "Indanan",
    "Jolo (Capital)",
    "Kalingalan Caluang",
    "Luuk",
    "Maimbung",
    "Hadji Panglima Tahil (Marunggas)",
    "Old Panamao",
    "Pangutaran",
    "Parang",
    "Pata",
    "Patikul",
    "Siasi",
    "Talipao",
    "Tapul",
    "Tongkil",
    "Panglima Estino (New Panamao)",
    "Lugus",
    "Pandami",
    "Omar",
    "Panglima Sugala (Balimbing)",
    "Bongao (Capital)",
    "Mapun (Cagayan De Tawi-tawi)",
    "Simunul",
    "Sitangkai",
    "South Ubian",
    "Tandubas",
    "Turtle Islands",
    "Languyan",
    "Sapa-sapa",
    "Sibutu",
    "Buenavista",
    "Butuan City (Capital)",
    "City Of Cabadbaran",
    "Carmen",
    "Jabonga",
    "Kitcharao",
    "Las Nieves",
    "Magallanes",
    "Nasipit",
    "Santiago",
    "Tubay",
    "Remedios T. Romualdez",
    "City Of Bayugan",
    "Bunawan",
    "Esperanza",
    "La Paz",
    "Loreto",
    "Prosperidad (Capital)",
    "Rosario",
    "San Francisco",
    "San Luis",
    "Santa Josefa",
    "Talacogon",
    "Trento",
    "Veruela",
    "Sibagat",
    "Alegria",
    "Bacuag",
    "Burgos",
    "Claver",
    "Dapa",
    "Del Carmen",
    "General Luna",
    "Gigaquit",
    "Mainit",
    "Malimono",
    "Pilar",
    "Placer",
    "San Benito",
    "San Francisco (Anao-aon)",
    "San Isidro",
    "Santa Monica (Sapao)",
    "Sison",
    "Socorro",
    "Surigao City (Capital)",
    "Tagana-an",
    "Tubod",
    "Barobo",
    "Bayabas",
    "City Of Bislig",
    "Cagwait",
    "Cantilan",
    "Carmen",
    "Carrascal",
    "Cortes",
    "Hinatuan",
    "Lanuza",
    "Lianga",
    "Lingig",
    "Madrid",
    "Marihatag",
    "San Agustin",
    "San Miguel",
    "Tagbina",
    "Tago",
    "City Of Tandag (Capital)",
    "Basilisa (Rizal)",
    "Cagdianao",
    "Dinagat",
    "Libjo (Albor)",
    "Loreto",
    "San Jose (Capital)",
    "Tubajon",
  ];

  static List<String> getSuggestions(String query) {
    List<String> matches = List();
    matches.addAll(cities);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}