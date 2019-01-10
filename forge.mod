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


s.t. OneTargetedPositionPerGB{gb in GBs}:
    sum{p in Positions} TargetedPosition[gb,p] <= ShouldContribute[gb];

s.t. PointsToContributeCantExceedStoredFp:
    sum{gb in GBs} (PointsToContribute[gb]) <= storedFP;

s.t. PointsContributedShouldNotExceedFPReward{gb in GBs,p in Positions}:
	PointsToContribute[gb]<=FPReward[gb,p] + M * (1-TargetedPosition[gb,p]);

s.t. PointsContributedShouldExceedPointsAlreadyInTargetedPositionIfGreaterThanZero{gb in GBs}:
    (PointsToContribute[gb]) >= ( sum{p in Positions} ( (ContributedByOthersPerPos[gb,p]) * TargetedPosition[gb,p]) );

s.t. SetPointsToContribute{gb in GBs}:
    PointsToContribute[gb] = sum{p in Positions} ((ContributedByOthersPerPos[gb,p]) * TargetedPosition[gb,p])+(TotalFPsNeededForNextLevel[gb] - AllPointsAlreadyContributed[gb]-sum{p in Positions} ((ContributedByOthersPerPos[gb,p]) * TargetedPosition[gb,p]))/2;

maximize Profit:
    sum{gb in GBs, p in Positions} TargetedPosition[gb,p] * FPReward[gb,p] - sum{gb in GBs} PointsToContribute[gb];


end;
