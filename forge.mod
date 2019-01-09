#Feladat: 
#A model a Forge of Empires játék egy gyakori problémáját hivatott megoldani. A játékos rendelkezik adott mennyiségû Forge Point-tal (FP), amelyet szét szeretne osztani optimálisan a rendelkezésre álló Great Building-ek (GB) között. Ha egy GB szintet lép, akkor a szintlépéshez hozzájáruló játékosok jutalmakat kapnak attól függõen, hogy milyen helyezést értek el. A helyezés attól függ, hogy mennyi FP-t fektettek az építkezésbe a többi befektetõhöz képest. Annál magasabb a jutalom, minél jobb helyezést ér el a játékos, és minél magasabb szintû az épület, illetve minden GB-nél különbözõek az értékek. A jutalom értékét százalékosan növeli a játékos Arc GB-je, annak szintjétõl függõen. Például egy 80-as szintû Arc 1.9-es szorzót jelent a jutalomra.
#Példa: "A" játékos "Lighthouse of Alexandria" GB-jében jelenleg 1500 FP van, és 3500 kell a következõ szint eléréséhez. "B" játékosnak 500 pontja van jelenleg az épületben, "C" játékosnak 250, "D" játékosnak 200, "A" játékosnak pedig 550. Jelen állás szerint "A" lenne az elsõ helyen, de mivel az õ GB-jérõl van szó, így õ nincs versenyben, tehát "B" van az elsõ helyen, "C" a második helyen és "D" a harmadik helyen. A jutalom az elsõ helyért 300 FP, 5 BP és 3000 Medál, a másodikért 200, 3, 2000 , a harmadikért 100, 2, 1000, a negyedikért 50, 1, 500, az ötödikért 10, 0, 250. A játékosunk ("E") Arc-ja 60-as szintû, ami 1.8-as szorzót jelent a jutalomra. Raktárában 1500 FP van, így azzal gazdálkodhat. "E"-nek el kell döntenie, hogy érdemes -e befektetnie "A" játékos "Lighthouse of Alexandria" GB-jébe, figyelembe véve, hogy jelenleg mennyi pontot fektettek játékosok az épületbe, és tekintettel a jutalmakra. 2000 pontot lehet rakni az épületbe maximum, mivel akkor éri el a 3500-at és lép szintet, és akkor történik a jutalomkalkuláció. A jutalom az elsõ helyért 300*1.8=540 FP "E" játékos számára, vagyis ennél többet nem éri meg befektetni. Ha 550-et fektet be, az azt jelenti, hogy még 1450 pont szabadon betehetõ az épületbe, tehát akárki megelõzheti, így a konklúzió az, hogy nem éri meg "E" játékosnak megkockáztatni jelenleg a befektetést egyik pozícióra sem (1-5), mivel még egyik sem biztosítható be (ha az elsõ hely nem biztosítható be, akkor a többi sem).

#Egy GB-hez az alábbi adatok tartoznak: (több GB is megadható, ez esetben a model elosztja a játékos FP-it optimálisan a GB-k között)
#1: Hány FP szükséges a következõ szint eléréséhez. (példában: 3500)
#2: Hány FP-t, Blueprintet (BP), Medált adnak az egyes pozíciók (példában: 300,5,3000	200,3,2000	100,2,1000	50,1,500	10,0,250)
#3. Az elsõ 5 pozícióra elhelyezett pontok (példában: 500,250,200)
#4. Hány FP-t fektettek összesen a jelenlegi szintbe (példában: 1500)

#Játékosunkhoz tartozó adatok:
#1: Hány FP van a raktárában (példában: 1500)
#2: Milyen szorzót biztosít az Arc-ja (példában: 1.8)

#Maximalizálandó az FP, BP és Medál profit, ebben a prioritási sorrendben (állítható a súlyok értéke).

set GBs:=1..numberOfGBs;
set Positions:=1..5;
set Resources:={"FPs","BPs","Medals"};
param RewardAmounts{GBs,Positions,Resources};
param FPPriority;
param BPPriority;
param MedalPriority;
param storedFP;
param arcBoost;

param numberOfGBs;
param TotalFPsNeededForNextLevel{GBs};
param ContributedByOthersPerPos{GBs,Positions};
param AlreadyContributedByPlayer{GBs};
param AllPointsAlreadyContributed{GBs};

param M;

var FurtherFPsNeededForNextLevel{GBs};
var TargetedPosition{GBs,Positions}, binary;
var ShouldContribute{GBs}, binary;
var PointsToContribute{GBs} >= 0;
var RewardValues{GBs, Positions} >= 0;



s.t. SetFurtherFPsNeededForNextLevel{gb in GBs}:
	FurtherFPsNeededForNextLevel[gb] = TotalFPsNeededForNextLevel[gb] - AllPointsAlreadyContributed[gb];

s.t. SetRewardValues{gb in GBs, p in Positions}:
	RewardValues[gb,p] = RewardAmounts[gb,p,"FPs"]*FPPriority + RewardAmounts[gb,p,"BPs"]*BPPriority + RewardAmounts[gb,p,"Medals"]*MedalPriority;

s.t. OneTargetedPositionPerGBAndNoTargetedPositionMeansNoContribution{gb in GBs}:
	sum{p in Positions} (TargetedPosition[gb,p]) = 1 * ShouldContribute[gb];

s.t. PointsToContributeCantExceedStoredFp:
	sum{gb in GBs} (PointsToContribute[gb]) * ShouldContribute[gb] <= storedFP;

s.t. PointsContributedShouldExceedTargetedPositionIfGreaterThanZero{gb in GBs}:
	(PointsToContribute[gb] + AlreadyContributedByPlayer[gb]) * ShouldContribute[gb] >= ( sum{p in Positions} ( (ContributedByOthersPerPos[gb,p] + 1) * TargetedPosition[gb,p]) );

s.t. ShouldOnlyContributeIfPositionIsSecured{gb in GBs}:
	#ha a shouldcontribute értéke 1 egy gb-nél, akkor a TotalFPsNeededForNextLevel mínusz (ContributedByOthersPerPos arra a pozícióra, ahol a TargetedPosition=1 + FurtherFPsNeededForNextLevel-PointsToContribute) legyen kisebb egyenlõ, mint a PointsToContribute+AlreadyContributedByPlayer arra a gb-re
	#LHS = TotalFPsNeededForNextLevel[gb] - (sum{p in Positions} (ContributedByOthersPerPos * TargetPosition[gb,p])

maximize Profit:
	(  (sum{gb in GBs, p in Positions} (TargetedPosition[gb,p] * RewardValues[gb,p])) - sum{gb in GBs} (PointsToContribute[gb])  ); 

