param numberOfGBs;
set GBs := 1..numberOfGBs;
set Positions := 1..5;
param FPAmounts{GBs,Positions};
param BPAmounts{GBs,Positions};
param MedalAmounts{GBs,Positions};
param FPPriority;
param BPPriority;
param MedalPriority;
param storedFP;
param arcBoost;


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
	RewardValues[gb,p] = FPAmounts[gb,p]*FPPriority + BPAmounts[gb,p]*BPPriority + MedalAmounts[gb,p]*MedalPriority;

s.t. OneTargetedPositionPerGBAndNoTargetedPositionMeansNoContribution{gb in GBs}:
	sum{p in Positions} TargetedPosition[gb,p] <= 1 + M * (1-ShouldContribute[gb]);

s.t. PointsToContributeCantExceedStoredFp:
	sum{gb in GBs} (PointsToContribute[gb]) <= storedFP;

s.t. PointsContributedShouldExceedTargetedPositionIfGreaterThanZero{gb in GBs}:
	(PointsToContribute[gb] + AlreadyContributedByPlayer[gb]) >= ( sum{p in Positions} ( (ContributedByOthersPerPos[gb,p] + 1) * TargetedPosition[gb,p]) );

s.t. ShouldOnlyContributeIfPositionIsSecured{gb in GBs}:
	(PointsToContribute[gb]+AlreadyContributedByPlayer[gb]) >= sum{p in Positions} ((ContributedByOthersPerPos[gb,p] + 1) * TargetedPosition[gb,p]) + (FurtherFPsNeededForNextLevel[gb] - PointsToContribute[gb] - M * (1-ShouldContribute[gb]));

	#Total Points Added By The Player  >= The maximum amount the player who occupied the position we are aiming for can put into the building 	, if this is true, it means nobody can take this place from us



maximize Profit:
	#(sum{gb in GBs, p in Positions} (RewardValues[gb,p])) - sum{gb in GBs} (PointsToContribute[gb])  ); 
	sum{gb in GBs, p in Positions} (RewardValues[gb,p] - M * (1 - TargetedPosition[gb,p])) - sum{gb in GBs} (FPPriority*PointsToContribute[gb]);

