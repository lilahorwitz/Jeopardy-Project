# Jeopardy-Project
This repository includes the code, a zip file containing the .csv file of the data necessary, and a project summary.
The project uses data from a csv file with 216,930 Jeopardy! questions ranging from 1984 to 2012 which can be found at this link: https://www.kaggle.com/datasets/tunguz/200000-jeopardy-questions 

The questions being addressed are: how do election years affect Jeopardy! questions? and do political Jeopardy! question increase during election years? 

# Method
The project works by loading metadata of text data. The metadata contains jeopardy questions other information about the question including the question's air date represented by a Date variable and a numeric variable. 
I created new date and year variables for each question and ordered the data by year. Then, I determined the start and end of each election year to create a new variable that denoted if the question was asked during an election year. 
I pre-processed the data uisng the functions textProcessor() and prepDocuments() for use in a Structural Topic Model. Note for code line 55-56: add max.em.its = n, n being the number of iterations to reprocess the data, otherwise the default is 500 iterations which is timely. 
The labelTopics() and findThoughts() functions are for each topic to determine the most popular words and demonstrate examples of questions with those words respectively. 

The estimateEffect() function is used in combination with plot() to plot the effects of year and whether the question was asked during an election year on topic prevalance. Using the method difference represents the difference between topics based on whether the questions were asked during election years or not and the method continuous represents the prevalance of an individual topic over the years. 

Note: to get a more complete picture of how election years affect Jeopardy! questions, do not run lines 21-22. These lines subset the data to only include data from after 2000. This was initially done for the sake of time and storage but limits the scope of the data. 

# Substantive Findings 
Based on the STM that uses the default max.em.its, the labelTopics(), and findThoughts() functions, I labeled ten different topics. I decided to use ten topics based on how the STM organized documents. Topic 8 seemed to be directly related to politics or have a poltical connotation. Based on the plot using the aforementioned method "difference", questions from topic 8 were more likely to occur during election years than non election years. A jpeg of this plot can be seen in this repository. 
