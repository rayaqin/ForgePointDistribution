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

var FPsGained, integer, >= 0;
var BPsGained, integer, >= 0;
var MedalsGained, integer, >= 0;


s.t. OneTargetedPositionPerGB:
    sum{p in Positions} TargetedPosition[p] <= 1;

s.t. PointsToContributeCantExceedStoredFp:
    PointsToContribute <= storedFP;

s.t. SetPointsToContribute:
    PointsToContribute >= 
    sum{p in Positions} 
        ((ContributedByOthersPerPos[p]) * TargetedPosition[p])
    +((TotalFPsNeededForNextLevel - AllPointsAlreadyContributed)*
      sum{p in Positions} (TargetedPosition[p]) - 
    sum{p in Positions} 
        ((ContributedByOthersPerPos[p]) * TargetedPosition[p])
      )/2;

s.t. SetFPsGained:
	FPsGained = sum{p in Positions} (TargetedPosition[p] * FPReward[p]) * arcBoost - PointsToContribute;

s.t. SetBPsGained:
	BPsGained = sum{p in Positions} (TargetedPosition[p] * BPReward[p]) * arcBoost;

s.t. SetMedalsGained:
	MedalsGained = sum{p in Positions} (TargetedPosition[p] * MedalReward[p]) * arcBoost;

maximize Profit:
    sum{p in Positions} (TargetedPosition[p] * FPReward[p]*arcBoost) -PointsToContribute;



solve;

printf "\n\n*************************************\n";
printf "\n\nResults printed for readability: \n\n";
printf "\n*************************************\n";
printf "\n\n- Forge Points gained: %g\n", sum{p in Positions} (TargetedPosition[p] * FPReward[p]) * arcBoost - PointsToContribute;
printf "\n\n- Blueprints gained: %g\n", sum{p in Positions} (TargetedPosition[p] * BPReward[p]) * arcBoost;
printf "\n\n- Medals gained: %g\n\n", sum{p in Positions} (TargetedPosition[p] * MedalReward[p]) * arcBoost;
printf "\n*************************************\n";
printf "\nTotal points gained considering priorities: [ %d ]\n", Profit;
printf "\n*************************************\n";



end;
