# Decoding Football: A Data Driven Exploration delving into Football Performances and Market Trends

### Tables of Content
- [Project Overview](#project-overview)
- [Key Visuals and Dashboards](#key-visuals-and-dashboards)
- [Key Findings](#key-findings)
- [Statistical Tests and Machine learning Models Key Findings](#statistical-tests-and-machine-learning-models-key-findings)
- [Focus Areas and Objectives](#focus-areas-and-objectives)
- [Data Sources](#data-sources)
- [Data Cleaning Performed](#data-cleaning-performed)

## Project Overview
This project analyzes football data to uncover insights into player and team performance, team comparison, market value trends, 
substitution patterns, and other key factors. It explores individual player contributions, competition-wise performance, and more.

## Key Visuals and Dashboards
[Tableau Public Dashboard Link](https://public.tableau.com/shared/799K2G62Z?:display_count=n&:origin=viz_share_link)

![Performance Dashboard](https://github.com/user-attachments/assets/4c7011e6-975f-47ee-974f-18d3fff0d695)

![Player Profile Dashboard](https://github.com/user-attachments/assets/87192593-b8bf-4319-bbc2-37bcf60e78e0)

![Referree Dashboard](https://github.com/user-attachments/assets/64dfff40-8532-488a-a4ce-22af5ba512c9)

![Substitution Dashboard](https://github.com/user-attachments/assets/c81d2954-20fa-4155-b3c1-1b8b597a360c)

![Team Competition Dashboard](https://github.com/user-attachments/assets/acb91830-7605-4f87-bec4-5ba932f58037)

![Contract & Agent Dashboard](https://github.com/user-attachments/assets/801d2635-4c40-4dd7-9277-f8a2fddf0bc6)



## Key Findings
1. Player Performance
	- **Top Contributors**
		- Christian Pulisic (avg. 4 goals/season) balances goals and assists; 
		- Aron Johannsson leads with 142 total goals but leans goal-focused; 
	- **Improvement Needed**
		- John Brooks (38 yellow cards) requires discipline improvements.
2. Market Trends
	- **Value Decline For Ages**: 
		- Players over Age of 30 see significant market value drop; 
	- **Value Decline For Position**:
		- defenders lose ~ €100K/year,
		- midfielders ~ €97K 
		- attackers ~ €77K
3. Team & Manager Comparison
	- **Dominant Teams**: 
		- **Barcelona** averages **3-goal home wins**, 
		- **Bayern Munich** has a domestic **23:1 win/loss ratio**; 
	- **Manager Performance**:
		- **Manager Thomas Tuchel** boasts a **9:1 win/loss rate**
4. Attendance Patterns
	- **Stadium Engagement**: 
		- Signal Iduna Park boosts **win rates >60%**; 
	- **Attendance Peak**:
		- weekend games fill stadiums to **73% capacity**. 
	- **Popular Teams**: 
		- **Borussia Dortmund** draws over **80,000 fans** consistently.
		- **Manchester United Club** draws over **75,000 fans** consistently
5. Referee & Event Influence
	- **Referee Discipline and Outcome Probability**: 
		- **Referee Felix Zwayer leads in yellow cards**
	- ** Event Impact on Winning**:
		- Late-game goals affect outcomes minimally, increasing **win probability by ~15% if scored before halftime**.
6. Substitutions
	- **Strategic Impact**: 
		- Key players, like Pulisic, frequently **score almost 60 % of the times** post-substitution; 
	- **Weakening Defence**: 
		- Right Backs and Center Backs see the most changes **(~250 substitutions)**, enhancing tactical depth.
7. Player Contracts
	- **Investment Opportunities**: 
		- 66 contracts end in June 2026, signaling a potential for strategic recruitment; 
	- **Agent Representations**: 
		- Wasserman Group leads in representation, managing 64 players.

## Statistical Tests and Machine learning Models Key Findings:
1. Logistic Regression for Predicting Yellow Cards based on Goals, Assists

	- Predict the likelihood of a player receiving a yellow card based on performance metrics.
	- **Achieved 87% precision for accurately predicting yellow-card outcomes**.
	- The model demonstrates also provides strong precision in predicting players who avoid yellow cards, making it **valuable for identifying both high and low-risk players**.

2. K-Means Clustering for Player Grouping by Market Value and Attributes
	- Cluster players by market value, height, country, and age to find investment opportunities.
	- Optimal Clusters of 12, determined by the Elbow method.
	- Effective segmentation into 12 clusters, allowing teams and investors to identify high-potential and under-valued talent.
	- The model provides a clear structure to identify distinct player groups, aiding strategic decisions in the transfer market.


3. K-Nearest Neighbors (KNN) for Stadium Attendance Classification

	- Classify stadiums based on attendance patterns.
	- **F1-score over 70%** for specific stadiums like **Signal Iduna Park and Veltins-Arena**.
	- The model performs effectively for high-attendance venues, making it useful for predicting crowd turnout at key stadiums, particularly for high-profile matches.

4. Linear Regression for Market Value Prediction

	- Predict player market value using goals, assists, and minutes played.
	- Model High Accuracy for Predicting Market value of Players with a **R Score of 76 %**
	- Highlights that market value is likely influenced by factors beyond traditional performance metrics

5. Hypothesis Testing for Impact of Goals Scored in the Last 15 Minutes

	- Evaluate whether goals in the final 15 minutes affect the match result.
	- **95% confidence level, late-game goals showed minimal impact** on final outcomes.
	- Emphasizes the importance of a consistent approach throughout the game, supporting teams in tactical decisions to strengthen play from the outset rather than relying on late-	   game strategies.


## Focus Areas and Objectives
1.  **Performance Analysis** - Analyzing player and team metrics across seasons.
2.  **Player Profile & Market Value Analysis** - Understanding player valuation based on performance.
3.  **Player Attributes & Demographics** - Understand how player attributes and demographics influence performance.
4.  **Team Comparison** - Compare Teams based on Performance and Managerial Choices.
5.  **Event Analysis** - Explore impact of key events during matches, impacting results.
6.  **Attendance & Stadium Analysis** - Exploring trends in attendance across various venues.
7.  **Referee Analysis** - Understand the Impact of Referees on Match Outcomes.
8.  **Substitution Patterns** - Studying substitution impact on game outcomes.
9.  **Competition Analysis** - Assess Player and Team Performance Across Seasons and Competitions.
10. **Contract Management** - Assessing Player contracts and agent representations for players.

## Data Sources
- **Source**: [Include sources, e.g., official league datasets, API references]
- **Details**: Provide a brief summary of your data, including player profiles, match events, competition details, etc.

## Tools Used
1. Microsoft Excel 			        --> Used mainly for pivot tables, conditional formatting and Excel Charts for PowerPoint Presentation
2. MySQL Workbench 			        --> To create joins and views to further analyse in Python or Excel
3. Python - NumPy, Pandas 		  --> For data-processing and working with the Data Sets to find insights
4. Python - Matplotlib, Seaborn --> For visualizing the insights for presenting data in a cleaner and visually appealing manner
5. Python - Scikit-learn		    --> For creating Machine Learning Models --> Linear Regression, Logistic Regression, K-Nearest Neighbors, K-Means Clustering
4. Tableau 				              --> For creating Interactive Dashboards mainly for visually presenting inter-related data for a focus area solving business questions
5. ROWS AI.com		              --> For performing level 1 analysis (understanding simple statistic questions like averages etc)
6. ChatGPT				              --> Used for building meaningful business questions, verifying Python, SQL codes and allowing to better paraphrase complex statistical and machine learning concepts

**NOTE** - The tools mentioned above are all used together and not for a specific objective nor in any specific order

## Data Cleaning Performed
All the missing values, outlier treatment, feature engineering for Machine Learning Models have been done using Python.

