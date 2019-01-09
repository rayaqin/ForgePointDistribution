#Feladat: 
#A model a Forge of Empires j�t�k egy gyakori probl�m�j�t hivatott megoldani. A j�t�kos rendelkezik adott mennyis�g� Forge Point-tal (FP), amelyet sz�t szeretne osztani optim�lisan a rendelkez�sre �ll� Great Building-ek (GB) k�z�tt. Ha egy GB szintet l�p, akkor a szintl�p�shez hozz�j�rul� j�t�kosok jutalmakat kapnak att�l f�gg�en, hogy milyen helyez�st �rtek el. A helyez�s att�l f�gg, hogy mennyi FP-t fektettek az �p�tkez�sbe a t�bbi befektet�h�z k�pest. Ann�l magasabb a jutalom, min�l jobb helyez�st �r el a j�t�kos, �s min�l magasabb szint� az �p�let, illetve minden GB-n�l k�l�nb�z�ek az �rt�kek. A jutalom �rt�k�t sz�zal�kosan n�veli a j�t�kos Arc GB-je, annak szintj�t�l f�gg�en. P�ld�ul egy 80-as szint� Arc 1.9-es szorz�t jelent a jutalomra.
#P�lda: "A" j�t�kos "Lighthouse of Alexandria" GB-j�ben jelenleg 1500 FP van, �s 3500 kell a k�vetkez� szint el�r�s�hez. "B" j�t�kosnak 500 pontja van jelenleg az �p�letben, "C" j�t�kosnak 250, "D" j�t�kosnak 200, "A" j�t�kosnak pedig 550. Jelen �ll�s szerint "A" lenne az els� helyen, de mivel az � GB-j�r�l van sz�, �gy � nincs versenyben, teh�t "B" van az els� helyen, "C" a m�sodik helyen �s "D" a harmadik helyen. A jutalom az els� hely�rt 300 FP, 5 BP �s 3000 Med�l, a m�sodik�rt 200, 3, 2000 , a harmadik�rt 100, 2, 1000, a negyedik�rt 50, 1, 500, az �t�dik�rt 10, 0, 250. A j�t�kosunk ("E") Arc-ja 60-as szint�, ami 1.8-as szorz�t jelent a jutalomra. Rakt�r�ban 1500 FP van, �gy azzal gazd�lkodhat. "E"-nek el kell d�ntenie, hogy �rdemes -e befektetnie "A" j�t�kos "Lighthouse of Alexandria" GB-j�be, figyelembe v�ve, hogy jelenleg mennyi pontot fektettek j�t�kosok az �p�letbe, �s tekintettel a jutalmakra. 2000 pontot lehet rakni az �p�letbe maximum, mivel akkor �ri el a 3500-at �s l�p szintet, �s akkor t�rt�nik a jutalomkalkul�ci�. A jutalom az els� hely�rt 300*1.8=540 FP "E" j�t�kos sz�m�ra, vagyis enn�l t�bbet nem �ri meg befektetni. Ha 550-et fektet be, az azt jelenti, hogy m�g 1450 pont szabadon betehet� az �p�letbe, teh�t ak�rki megel�zheti, �gy a konkl�zi� az, hogy nem �ri meg "E" j�t�kosnak megkock�ztatni jelenleg a befektet�st egyik poz�ci�ra sem (1-5), mivel m�g egyik sem biztos�that� be (ha az els� hely nem biztos�that� be, akkor a t�bbi sem).

#Egy GB-hez az al�bbi adatok tartoznak: (t�bb GB is megadhat�, ez esetben a model elosztja a j�t�kos FP-it optim�lisan a GB-k k�z�tt)
#1: H�ny FP sz�ks�ges a k�vetkez� szint el�r�s�hez. (p�ld�ban: 3500)
#2: H�ny FP-t, Blueprintet (BP), Med�lt adnak az egyes poz�ci�k (p�ld�ban: 300,5,3000	200,3,2000	100,2,1000	50,1,500	10,0,250)
#3. Az els� 5 poz�ci�ra elhelyezett pontok (p�ld�ban: 500,250,200)
#4. H�ny FP-t fektettek �sszesen a jelenlegi szintbe (p�ld�ban: 1500)

#J�t�kosunkhoz tartoz� adatok:
#1: H�ny FP van a rakt�r�ban (p�ld�ban: 1500)
#2: Milyen szorz�t biztos�t az Arc-ja (p�ld�ban: 1.8)

#Maximaliz�land� az FP, BP �s Med�l profit, ebben a priorit�si sorrendben (�ll�that� a s�lyok �rt�ke).

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
	#ha a shouldcontribute �rt�ke 1 egy gb-n�l, akkor a TotalFPsNeededForNextLevel m�nusz (ContributedByOthersPerPos arra a poz�ci�ra, ahol a TargetedPosition=1 + FurtherFPsNeededForNextLevel-PointsToContribute) legyen kisebb egyenl�, mint a PointsToContribute+AlreadyContributedByPlayer arra a gb-re
	#LHS = TotalFPsNeededForNextLevel[gb] - (sum{p in Positions} (ContributedByOthersPerPos * TargetPosition[gb,p])

maximize Profit:
	(  (sum{gb in GBs, p in Positions} (TargetedPosition[gb,p] * RewardValues[gb,p])) - sum{gb in GBs} (PointsToContribute[gb])  ); 

