param numberOfGBs;
set GBs := 1..numberOfGBs;
set Positions := 1..5;
param FPReward{GBs,Positions};
param BPReward{GBs,Positions};
param MedalReward{GBs,Positions};
param FPPriority;
param BPPriority;
param MedalPriority;
param storedFP;
param arcBoost;


param TotalFPsNeededForNextLevel{GBs};
param ContributedByOthersPerPos{GBs,Positions};
param AllPointsAlreadyContributed{GBs};

param M;

var TargetedPosition{GBs,Positions}, binary;
var ShouldContribute{GBs}, binary;
var PointsToContribute{GBs} >= 0;



s.t. OneTargetedPositionPerGBAndNoTargetedPositionMeansNoContribution{gb in GBs}:
    sum{p in Positions} TargetedPosition[gb,p] <= 1;

s.t. PointsToContributeCantExceedStoredFp:
    sum{gb in GBs} (PointsToContribute[gb]) <= storedFP;

#s.t. PointsContributedShouldExceedTargetedPositionIfGreaterThanZero{gb in GBs}:
#    (PointsToContribute[gb]) >= ( sum{p in Positions} ( (ContributedByOthersPerPos[gb,p] + 1) * TargetedPosition[gb,p]) );

s.t. SetPointsToContribute{gb in GBs}
	PointsToContribute[gb] = sum{p in Positions} ((ContributedByOthersPerPos[gb,p] + 1) * TargetedPosition[gb,p]) + ( TotalFPsNeededForNextLevel[gb] - AllPointsAlreadyContributed[gb] - sum{p in Positions} ((ContributedByOthersPerPos[gb,p] + 1) * TargetedPosition[gb,p])) / 2;

s.t. ShouldOnlyContributeIfPositionIsSecured{gb in GBs}:
    (PointsToContribute[gb]) >= sum{p in Positions} ((ContributedByOthersPerPos[gb,p]) * TargetedPosition[gb,p]) + (TotalFPsNeededForNextLevel[gb] - AllPointsAlreadyContributed[gb]) - PointsToContribute[gb];

maximize Profit:
    sum{gb in GBs, p in Positions} (TargetedPosition[gb,p] * (FPReward[gb,p] + BPReward[gb,p] + MedalReward[gb,p])) - sum{gb in GBs} (PointsToContribute[gb]);