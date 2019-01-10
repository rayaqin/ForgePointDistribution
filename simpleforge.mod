set Positions := 1..5;
param storedFP;
param arcBoost;

param FPReward{Positions};
param BPReward{Positions};
param MedalReward{Positions};
param FPPriority;
param BPPriority;
param MedalPriority;

param TotalFPsNeededForNextLevel;
param ContributedByOthersPerPos{Positions};
param AllPointsAlreadyContributed;

param M;

var TargetedPosition{Positions}, binary;
var PointsToContribute, integer, >= 0;


s.t. OneTargetedPositionPerGB:
    sum{p in Positions} TargetedPosition[p] <= 1;

s.t. PointsToContributeCantExceedStoredFp:
    PointsToContribute <= storedFP;

s.t. MakeItWorthIt:
	PointsToContribute <= sum{p in Positions} (TargetedPosition[p] * FPReward[p]);

s.t. RemainingContribution:
    PointsToContribute <= TotalFPsNeededForNextLevel-AllPointsAlreadyContributed;

s.t. SetPointsToContribute:
    PointsToContribute = 
    sum{p in Positions} 
        ((ContributedByOthersPerPos[p]) * TargetedPosition[p])
    +((TotalFPsNeededForNextLevel - AllPointsAlreadyContributed)*
      sum{p in Positions} (TargetedPosition[p]) - 
    sum{p in Positions} 
        ((ContributedByOthersPerPos[p]) * TargetedPosition[p])
      )/2;


maximize Profit:
    sum{p in Positions} (TargetedPosition[p] * FPReward[p]*FPPriority)*arcBoost+
	sum{p in Positions} (TargetedPosition[p] * BPReward[p]*BPPriority)*arcBoost+
	sum{p in Positions} (TargetedPosition[p] * MedalReward[p]*MedalPriority)*arcBoost-
	PointsToContribute*FPPriority;

solve;

printf "\n\n*************************************\n";
printf "\n\nResults printed for readability: \n\n";
printf "\n*************************************\n";
printf "\n- Forge Points spent: %d\n", PointsToContribute;
printf "\n*************************************\n";
printf "\n\n- Forge Points gained: %d\n", sum{p in Positions} (TargetedPosition[p] * FPReward[p]) * arcBoost - PointsToContribute;
printf "\n\n- Blueprints gained: %d\n", sum{p in Positions} (TargetedPosition[p] * BPReward[p]) * arcBoost;
printf "\n\n- Medals gained: %d\n\n", sum{p in Positions} (TargetedPosition[p] * MedalReward[p]) * arcBoost;
printf "\n*************************************\n";
printf "\nTotal points gained considering priorities: [ %d ]\n", Profit;
printf "\n*************************************\n";



end;
