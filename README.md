ForgePointDistribution


Feladat: 
A model a Forge of Empires játék egy gyakori problémáját hivatott megoldani. A játékos rendelkezik adott mennyiségű Forge Point-tal (FP), amelyet szét szeretne osztani optimálisan a rendelkezésre álló Great Building-ek (GB) között. Ha egy GB szintet lép, akkor a szintlépéshez hozzájáruló játékosok jutalmakat kapnak attól függően, hogy milyen helyezést értek el. A helyezés attól függ, hogy mennyi FP-t fektettek az építkezésbe a többi befektetőhöz képest. Annál magasabb a jutalom, minél jobb helyezést ér el a játékos, és minél magasabb szintű az épület, illetve minden GB-nél különbözőek az értékek. A jutalom értékét százalékosan növeli a játékos Arc GB-je, annak szintjétől függően. Például egy 80-as szintű Arc 1.9-es szorzót jelent a jutalomra.

Példa: "A" játékos "Lighthouse of Alexandria" GB-jében jelenleg 1500 FP van, és 3500 kell a következő szint eléréséhez. "B" játékosnak 500 pontja van jelenleg az épületben, "C" játékosnak 250, "D" játékosnak 200, "A" játékosnak pedig 550. Jelen állás szerint "A" lenne az első helyen, de mivel az ő GB-jéről van szó, így ő nincs versenyben, tehát "B" van az első helyen, "C" a második helyen és "D" a harmadik helyen. A jutalom az első helyért 300 FP, 5 BP és 3000 Medál, a másodikért 200, 3, 2000 , a harmadikért 100, 2, 1000, a negyedikért 50, 1, 500, az ötödikért 10, 0, 250. A játékosunk ("E") Arc-ja 60-as szintű, ami 1.8-as szorzót jelent a jutalomra. Raktárában 1500 FP van, így azzal gazdálkodhat. "E"-nek el kell döntenie, hogy érdemes -e befektetnie "A" játékos "Lighthouse of Alexandria" GB-jébe, figyelembe véve, hogy jelenleg mennyi pontot fektettek játékosok az épületbe, és tekintettel a jutalmakra. 2000 pontot lehet rakni az épületbe maximum, mivel akkor éri el a 3500-at és lép szintet, és akkor történik a jutalomkalkuláció. A jutalom az első helyért 300*1.8=540 FP "E" játékos számára, vagyis ennél többet nem éri meg befektetni. Ha 550-et fektet be, az azt jelenti, hogy még 1450 pont szabadon betehető az épületbe, tehát akárki megelőzheti, így a konklúzió az, hogy nem éri meg "E" játékosnak megkockáztatni jelenleg a befektetést egyik pozícióra sem (1-5), mivel még egyik sem biztosítható be (ha az első hely nem biztosítható be, akkor a többi sem).

Egy GB-hez az alábbi adatok tartoznak: (több GB is megadható, ez esetben a model elosztja a játékos FP-it optimálisan a GB-k között)
1: Hány FP szükséges a következő szint eléréséhez. (példában: 3500)
2: Hány FP-t, Blueprintet (BP), Medált adnak az egyes pozíciók (példában: 300,5,3000	200,3,2000	100,2,1000	50,1,500	10,0,250)
3: Az első 5 pozícióra elhelyezett pontok (példában: 500,250,200)
4: Hány FP-t fektettek összesen a jelenlegi szintbe (példában: 1500)

Játékosunkhoz tartozó adatok:
1: Hány FP van a raktárában (példában: 1500)
2: Milyen szorzót biztosít az Arc-ja (példában: 1.8)

Maximalizálandó az FP, BP és Medál profit, ebben a prioritási sorrendben (állítható a súlyok értéke).