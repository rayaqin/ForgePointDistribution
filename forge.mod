
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

