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

var PointsAlreadyIn{GBs} >= 0;
var PointsNeededUntilNextLvl{GBs} >= 0;

var FPProfit >= 0 , integer;
var BPProfit >= 0 , integer;
var MedalProfit >= 0 , integer;
var AllFPsSpent >= 0 , integer;

s.t. SetPointsNeededUntilNextLvl{gb in GBs}:
	PointsNeededUntilNextLvl[gb] = TotalFPsNeededForNextLevel[gb] - AllPointsAlreadyContributed[gb];

s.t. SetPointsAlreadyIn{gb in GBs}:
    PointsAlreadyIn[gb] = sum{p in Positions} (ContributedByOthersPerPos[gb,p] * TargetedPosition[gb,p]);

s.t. MaxOneTargetedPositionCanBePerOneGB{gb in GBs}:
	sum{p in Positions} TargetedPosition[gb,p] <= 1;

s.t. IfShouldContributeIsZeroTargetedPositionIsZero{gb in GBs,p in Positions}:
	TargetedPosition[gb,p] <= ShouldContribute[gb];

s.t. SetPointsToContributeIfShouldContributeIsOne{gb in GBs}:
	PointsToContribute[gb] >= ( (PointsAlreadyIn[gb] + PointsNeededUntilNextLvl[gb]) /2 ) - M*(1-ShouldContribute[gb]);

s.t. PointsToContributeShouldBeLessThanPointsNeededUntilNextLvl{gb in GBs}:
	PointsToContribute[gb] <= PointsNeededUntilNextLvl[gb]-1;

s.t. ShouldBeBeneficialSoMakeProfitBeOverZero:
(sum{gb in GBs, p in Positions} (FPReward[gb,p] * TargetedPosition[gb,p])) * arcBoost - sum{gb in GBs} PointsToContribute[gb] >= 0;

s.t. PointsContributedCantExceedStoredFP:
sum{gb in GBs} PointsToContribute[gb] <= storedFP;

maximize Profit:
    (sum{gb in GBs, p in Positions} (TargetedPosition[gb,p] * FPReward[gb,p]*FPPriority)+
    sum{gb in GBs, p in Positions} (TargetedPosition[gb,p] * BPReward[gb,p]*BPPriority)+
    sum{gb in GBs, p in Positions} (TargetedPosition[gb,p] * MedalReward[gb,p]*MedalPriority))
    * arcBoost - sum{gb in GBs} PointsToContribute[gb];

solve;

printf "\n\n*************************************\n";
printf "\n\nResults printed for readability: \n\n";
printf "\n*************************************\n";
printf "\n- Forge Points spent: %d\n", sum{gb in GBs} PointsToContribute[gb];
printf "\n*************************************\n";
printf "\n\n- Forge Points gained: %d\n", sum{gb in GBs, p in Positions} (TargetedPosition[gb,p] * FPReward[gb,p] * arcBoost) - sum{gb in GBs} PointsToContribute[gb];
printf "\n\n- Blueprints gained: %d\n", sum{gb in GBs, p in Positions} (TargetedPosition[gb,p] * BPReward[gb,p] * arcBoost);
printf "\n\n- Medals gained: %d\n\n", sum{gb in GBs, p in Positions} (TargetedPosition[gb,p] * MedalReward[gb,p] * arcBoost);
printf "\n*************************************\n";
printf "\nTotal points gained considering priorities: [ %d ]\n", Profit;
printf "\n*************************************\n";

end;
