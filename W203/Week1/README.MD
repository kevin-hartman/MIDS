---
title: W203 Week 1 | Class Introduction
---

# Week 1 | Class Introduction

Required readings:
* Devore, J. L. (2015). Probability and statistics for engineering and the sciences. Boston, MA: Cengage Learning. Chapter 1.
  * Full book [here](./../Books/probability_and_statistics_for_engineering_and_the_sciences.pdf)
* Fox, J., & Weisberg, S. (2011). An R companion to applied regression. Thousand Oaks, CA: Sage Publications. Chapters [1.1](./../Study.net/Fox__J__2011__An_R_Companion_To_Applied_Regression__Chapter_1__Section_1_1__R_Basics.pdf), [1.4](./../Study.net/Fox__J__2011__An_R_Companion_To_Applied_Regression__Chapter_1__Section_1_4__Generic_Functi___.pdf), [2.1](./../Study.net/Fox__J__2011__An_R_Companion_To_Applied_Regression__Chapter_2__Section_2_1__Data_Input.pdf), [2.2](./../Study.net/Fox__J__2011__An_R_Companion_To_Applied_Regression__Chapter_2__Section_2_2__Working_with_D___.pdf), and [2.3](./../Study.net/Fox__J__2011__An_R_Companion_To_Applied_Regression__Chapter_2__Section_2_3__Matrices__Arra___.pdf).

Live Session Notes
* Use pencil and paper when Paul goes to the blackboard.
* Get familiar with Tidy -?
* If you want to be running R in Python: R2Py or a subprocess
* Breakout Questions
  * Why do you need to know classical statistics, when we have fancy machine learning algorithms that can classify and predict with amazing accuracy?
    * Some of them work. Not all. Sometimes no patterns emerge
    * Need 10,000 or 1M samples
    * Need to label the data with high confidence.
    * If you want to use those algorithms appropriately you need to understand the fundamentals behind it.
    * You can determine the individual contribution of each of the variables. It’s transparent
  * Why isn't descriptive statistics enough for your career?
    * In general no body wants to analyze the data that already happened. Useful in the beginning but it is information about your sample.
    * With inferential statistics  - P value.
    * Chance of getting what you see by random chance. Can make decisions and see that two things are very different.
  * What mistake might result from confusing a sample mean for a population mean?
    * False positives and false negatives
    * Definitions:
      * Population mean - true data that’s out there that we never know
      * Sample mean - when you collect a sample and you average that
      * Mean - estimator, like a rule
      * Expected value / estimator = expected mean
      * When I select different samples my sample mean will change. That variance is called variance of mean.
      * Sample variance is the variance within the sample
    * Key thing - randomization of data that is not biased so that we can estimate the population mean

[Live Session Notebook](https://nbviewer.jupyter.org/urls/kevin-hartman.github.io/MIDS/W203/Week1/unit_1_ls/unit_1_ls.ipynb)
