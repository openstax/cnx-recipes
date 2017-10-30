#Creating a strong base for usuability (and an effort to avoid repetition code)
  This are thoughts that occured to me while going over the physics recipe file. They aim at establishing a structure that would allow for easier recipe creation as well as maintenability later down the road. 
  
## Collation vs numbering rules
Should we separate those two aspects in sections/files? 
Numbering should be fairly standard, with one or two options at most, without ad hoc cases while collations are book specific. The desired numbering scheme or template could be included, while collations would be specified when creating a new recipe, reducing the amount of time overall and avoiding repetition code each time we define a recipe
  
## General collation rules vs Book level collations
Rules like summary, glossary, index, attributions etc. should/could be consitent from book to book, thus falling into something similar to numbering. One of the benefis of this approach, aside from ease of use and time saving, is to create a consistent design for all the books and help creating an Openstax identity, a "feel" that would be our trademark. They could be defined once then included, for example. This would create a distinction between general styles vs book specific styles. 
  
  
##Possible file structure 
A modular approach to the different itmems needed
collation
  * includes folder
    * numbering.less
    * utilities.less (or some other name, this would contain the glossary, summary, index etc)
  * books folder
    * physics.less
    * book_name.less
    * etc
