using System;
					
public class Program
{
	public static void Main()
	{
		
		var maintenance = new [] {500, 750, 1500, 2000};
		var tradeInValue = new [] {8000, 6500, 5000, 0};
		var stages = 7;
		var states = 4;
		var newMachineCost = 10000;
		var inf = int.MaxValue;
		
		var dp = new int[states,stages];
		
		for (var stage = stages - 1; stage >= 0; stage--)
		{
			for (var state = 0; state < states; state++)
			{
				var replaceCost = 0;
				var keepCost = 0;
				
				// Final stage:
				if (stage >= stages - 1)
				{
					replaceCost = maintenance[state] - tradeInValue[state];
					keepCost = inf;
				}
				else
				{
					replaceCost = maintenance[state] - tradeInValue[state] + newMachineCost + dp[0, stage + 1];
					
					if (state >= 3)
					{
						keepCost = inf;
						
					}
					else
					{
						keepCost = maintenance[state] + dp[state + 1, stage + 1];
					}
				}
				
				dp[state, stage] = Math.Min(replaceCost, keepCost);
			}
		}
		
		int rowLength = dp.GetLength(0);
        int colLength = dp.GetLength(1);

        for (int i = 0; i < rowLength; i++)
        {
            for (int j = 0; j < colLength; j++)
            {
                Console.Write(string.Format("{0} ", dp[i, j]));
            }
            Console.Write(Environment.NewLine + Environment.NewLine);
        }
    }
}
