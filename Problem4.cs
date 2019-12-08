namespace UWCFRM507A3Q4
{
    // You are a private equity fund manager screening investment opportunities. 
    // Over the next 3 years you anticipate finding one opportunity per month and seek to build a portfolio of between 14 and 16 investments with the highest expected return. 
    // As you screen the opportunities, you estimate an anticipated return level.
    // Of course, there is no telling whether the opportunities will actually provide the anticipated return, but you do your best to evaluate them nonetheless. 
    // The anticipated return levels and the probabilities that each month’s project will be assessed at that level are shown in the table below.
    // 
    // Anticipated Return Level                 Probability
    //         20%                                  15% 
    //         15%                                  20% 
    //         10%                                  25% 
    //    less than 10%                             40%
    // 
    // You invest equal amounts in all opportunities that are funded and seek to build a portfolio with the highest anticipated return.
    // Unlike the real world, in this homework problem you must decide whether to invest in an opportunity at the time it is proposed or those seeking capital will call on a different funder.
    // You are not allowed to invest in projects anticipated to have less than a 10% return.
    // There is a penalty for failing to invest in at least 14 projects. The penalty is a 4% decrement to your average return for each project less than 14. For example, if you only end up with 12 projects, you incur a penalty of 0.08 (i.e. 8%). Your objective is to maximize your expected return minus any penalties.

    // (a) What are the stages, states and available decisions for this problem?
    // (b) Please specify the recursive relationship that allows the Dynamic Programming solution method proceed from stage to stage.
    // (c) Will you use forward or backward recursion?
    // (d) You are in month 36 committed to 15 investments. You anticipate that this
    // 36th project will have a 20% return. Do you choose to invest in it?
    // (e) You are in month 34 with an average anticipated return of 16% from the 13 projects to which you have already committed. You anticipate that this 34th project will have a return of 15%. Do you choose to invest in it?
    // (f) You are the private equity manager in problem 4 and you find yourself in month 33 committed to 12 of the 32 projects that you have already reviewed and with an average anticipated return of 14% and you anticipate that this 33rd project will have a 10% return,What do you do? Do you commit to the project even though it will lower your average return or do you decline to participate and wait for the next one?

    using System;
    using System.Collections.Generic;

    public class Program
    {
        // CFRM 507: Investing in projects one at a time.
        // This mimics the secretary problem,
        // so probably this code could be reused in the future.
        // This code puts readability ahead of optimization.
        // It's for learning purposes.

        private const int Stages = 37;
        private const int MaximumNumberOfProjects = 16;
        private const int MinimumNumberOfProjects = 14;

        // [stage, state, payoff so far, current payoff] => payoff.
        private static IDictionary<int, Dictionary<int, Dictionary<double, Dictionary<double, double>>>> dp =
            new Dictionary<int, Dictionary<int, Dictionary<double, Dictionary<double, double>>>>();

        public static void Main()
        {
            // Probabilities of the next project / secretary:
            var probabilities = new[] { 0.15, 0.2, 0.25, 0.4 };

            // Payoffs: Notice that we replaced <10 by 0 since we can't
            // invest in it anyway. This can be translated to how skillful
            // next secretary is going to be in our analogy.
            var payoffs = new[] { 0.2, 0.15, 0.1, 0 };

            // Setting up the final stage. This is the penalty in case that
            // we fail to invest in at least MinimumNumberOfProjects.
            // Also can be translated to failing to hiring x number of
            // secretaries. The way I perceive this problem is that it's
            // the secretary problem repeated many times.
            for (var i = 1; i < MinimumNumberOfProjects; i++)
            {
                ModifyDPMap(dp, Stages, i, -1, -1, -(MinimumNumberOfProjects - i) * 0.04);
            }

            // If we incur no penalty, then we set it to zero.
            for (var i = MinimumNumberOfProjects; i <= MaximumNumberOfProjects; i++)
            {
                ModifyDPMap(dp, Stages, i, -1, -1, 0);
            }

            // Problem: e.
            // If we are presented by an investment opportunity of payoff: 0.15 at 
            // time = 34 and we've already invested in 13 projects, should we invest in it or not?
            // Let's calculate state 36 first and then state 35 and then state 34.

            //var stage = 34;
            //var state = 13;
            //var paoffSoFar = 0.16;
            //var stagePayoff = 0.15;

            //var valueFunction = SetState(
            //    dp,
            //    stage,
            //    state,
            //    probabilities,
            //    payoffs,
            //    paoffSoFar,
            //    stagePayoff);

            // Problem: f.
            // You find yourself in month 33 committed to 12 of the 32 projects with an average anticipated return of 14%.
            // You anticipate that this 33rd project will have a 10% return, What do you do?
            // Do you commit to the project or do you decline to participate and wait for the next one?
            var stage = 33;
            var state = 12;
            var paoffSoFar = 0.14;
            var stagePayoff = 0.1;

            var valueFunction = SetState(
                dp,
                stage,
                state,
                probabilities,
                payoffs,
                paoffSoFar,
                stagePayoff);

            Console.ReadLine();
        }

        private static double SetState(
            IDictionary<int, Dictionary<int, Dictionary<double, Dictionary<double, double>>>> dp,
            int stage,
            int state,
            double[] probabilities,
            double[] payoffs,
            double payoffSoFar,
            double stagePayoff)
        {
            // The decision that we want to make is to either take it or leave it.
            // Let's get the maximum of these two decisions, this should be
            // the maximum of the current stage in our dynamic programming sub-structure.
            if (stage == Stages)
            {
                // return the penalty regardless of the payoff so far and current payoff.
                var valueFunction = payoffSoFar + dp[stage][state][-1][-1];
                //Console.WriteLine("stage: " + stage + ", state: " + state + ", value function: " + valueFunction);
                return valueFunction;
            }

            var memoizedValue = GetMemoizedValue(dp, stage, state, payoffSoFar, stagePayoff);
            if (memoizedValue != -1)
            {
                return memoizedValue;
            }

            // What if you have already taken the maximum number of projects?
            if (state >= MaximumNumberOfProjects)
            {
                return SetState(dp, stage + 1, state, probabilities, payoffs, payoffSoFar, -1);
            }

            // What if the payoff of the future is not known, i.e. stagePayoff = -1?
            // We should take an expectation.
            if (stagePayoff == -1)
            {
                var valueFunctionExpectation = 0d;

                for (var i = 0; i < payoffs.Length; i++)
                {
                    var payoff = payoffs[i];
                    var probability = probabilities[i];

                    if (payoff == 0)
                    {
                        var futurePayoff = SetState(dp, stage + 1, state, probabilities, payoffs, payoffSoFar, -1);
                        valueFunctionExpectation += futurePayoff * probability;
                        Console.WriteLine("The value function at stage: {1} and state: {2} and average return so far: {3} and current's project return: {4} is: {0}. We can NOT invest anyway.", futurePayoff, stage, state, payoffSoFar, payoff);
                    }
                    else
                    {
                        // Evaluate whether to take it or no.
                        var newPayoffSoFar = (payoffSoFar * (state) + payoff) / (state + 1);
                        var futurePayoff1 = SetState(dp, stage + 1, state + 1, probabilities, payoffs, newPayoffSoFar, -1);
                        var futurePayoff2 = SetState(dp, stage + 1, state, probabilities, payoffs, payoffSoFar, -1);
                        Console.WriteLine("The value function if we choose to invest at stage: {1} and state: {2} and average return so far: {3} and current's project return: {4} is: {0}", futurePayoff1, stage, state, newPayoffSoFar, payoff);
                        Console.WriteLine("The value function if we do NOT choose to invest at stage: {1} and state: {2} and average return so far: {3} and current's project return: {4} is: {0}", futurePayoff2, stage, state, payoffSoFar, payoff);
                        valueFunctionExpectation += Math.Max(futurePayoff1, futurePayoff2) * probability;
                    }
                }

                Console.WriteLine("The value function expectation at stage = {0} and state = {1} with payoff so far = {2} and stage payoff = {3} is equal to {4}", stage, state, payoffSoFar, stagePayoff, valueFunctionExpectation);
                ModifyDPMap(dp, stage, state, payoffSoFar, stagePayoff, valueFunctionExpectation);

                return valueFunctionExpectation;
            }
            else
            {
                var valueFunction = 0d;
                var beatenFunction = 0d;

                if (stagePayoff == 0)
                {
                    valueFunction = SetState(dp, stage + 1, state, probabilities, payoffs, payoffSoFar, -1);
                }
                else
                {
                    // Evaluate whether to take it or no.
                    var newPayoffSoFar = (payoffSoFar * state + stagePayoff) / (state + 1);
                    var futurePayoff1 = SetState(dp, stage + 1, state + 1, probabilities, payoffs, newPayoffSoFar, -1);
                    var futurePayoff2 = SetState(dp, stage + 1, state, probabilities, payoffs, payoffSoFar, -1);

                    if (futurePayoff1 > ß)
                    {
                        Console.WriteLine("TAKE IT");
                    }
                    else
                    {
                        Console.WriteLine("LEAVE IT");
                    }

                    valueFunction = Math.Max(futurePayoff1, futurePayoff2);
                    beatenFunction = Math.Min(futurePayoff1, futurePayoff2);
                }

                Console.WriteLine(
                    "The value function expectation at stage = {0} and state = {1} with payoff so far = {2} and stage payoff = {3} is equal to {4}, beating the alternative: {5}",
                    stage,
                    state,
                    payoffSoFar,
                    stagePayoff,
                    valueFunction,
                    beatenFunction);
                ModifyDPMap(dp, stage, state, payoffSoFar, stagePayoff, valueFunction);
                return valueFunction;
            }
        }

        private static void ModifyDPMap(
            IDictionary<int, Dictionary<int, Dictionary<double, Dictionary<double, double>>>> dp,
            int stage,
            int state,
            double payoffSoFar,
            double stagePayoff,
            double valueFunctionValue)
        {
            if (!dp.ContainsKey(stage))
            {
                dp[stage] = new Dictionary<int, Dictionary<double, Dictionary<double, double>>>();
            }

            if (!dp[stage].ContainsKey(state))
            {
                dp[stage][state] = new Dictionary<double, Dictionary<double, double>>();
            }

            if (!dp[stage][state].ContainsKey(payoffSoFar))
            {
                dp[stage][state][payoffSoFar] = new Dictionary<double, double>();
            }

            if (!dp[stage][state][payoffSoFar].ContainsKey(stagePayoff))
            {
                dp[stage][state][payoffSoFar][stagePayoff] = valueFunctionValue;
            }
        }

        private static double GetMemoizedValue(
            IDictionary<int, Dictionary<int, Dictionary<double, Dictionary<double, double>>>> dp,
            int stage,
            int state,
            double payoffSoFar,
            double stagePayoff)
        {
            if (!dp.ContainsKey(stage))
            {
                return -1;
            }

            if (!dp[stage].ContainsKey(state))
            {
                return -1;
            }

            if (!dp[stage][state].ContainsKey(payoffSoFar))
            {
                return -1;
            }

            if (!dp[stage][state][payoffSoFar].ContainsKey(stagePayoff))
            {
                return -1;
            }

            return dp[stage][state][payoffSoFar][stagePayoff];
        }
    }
}