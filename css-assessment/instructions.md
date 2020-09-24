Hello! 
Thank you for taking the time to complete this assessment. 

If you have any questions, please feel free to email BrittanyJ at bj20@rice.edu . 

# Instructions

Following the design specificiations below, use sass or css to style the book content provided in `biology.xhtml` to match the example page in the reference image [here](css-assessment/img/FullPage.png). 

Use PrinceXML to generate a styled PDF with the book content provided and add the PDF of your final design to the  `./final-design` folder. 

PrinceXML installation documentation can be found [here](https://www.princexml.com/doc/installing/).

And instruction on how to generate a styled PDF using PrinceXML can be found [here](https://www.princexml.com/doc/command-line/).

When you are finished with the assement and have push your changes to your forked repository, email BrittanyJ at bj20@rice.edu with a link to the repo. 

### Tips
- Use your web browser and dev tools inspector during developement as you normally would but keep in mind that your final output is the PDF, not the web. 
- The position and size of styled content in your browser will be different than the content in the PDF
- It is recommened to check the browser and PDF output both frequently to ensure that your style is appearing as you intend in the PDF 
- The `Element container selector`'s listed below are provided to help you identify which item on the page is being referenced in the specs. This is not to say that the styles provided below it should be directtly applied to that selector. For example, the `Element container selector` most likely contains children elements that the properties provided can be applied to. 
- Questions are welcomed and encouraged, remember that you can email BrittanyJ at bj20@rice.edu 

## More Context

The purpose of this task is to guage your profiency in CSS, Git/Github, and the command line. It also gives you a glimpse of the type of work you would be doing as a memeber of the styles team. 

When creating new styles for books, we are typicaly given design specifications such as the font size, font weight, color, and so on. But, there are still many CSS properties that you must come up with yourself to acheive the desired visual effect. 

A broad overview of a typical workflow for implementing a new design is as follows: 

- New design presented to team by product manager in a card on Zenhub
- A developer on the styles team will review the card and ask any inital questions that they may have about the design and specs provided 
- The developer will implement the style as closely as possible using the design specs provided and any additional information given by the product manager 
- The developer submits a screenshot of their final implementation to the product manager for design review and the product manager provides feedback 
 
# Page Elements 

- Default font color is #000000
- Default font is 
- Default font size is 12px

## Chapter Title
- [Reference Image](css-assessment/img/ChapterTitle.png)
- **Element container selector**: `h1 [data-type="document-title"]`

`Chapter 1`  Title Text: 
  - text color: #0074BC
  - right margin: 8px  
  - font weight: bolder 
  - line height: 1.5rem 
  - font family: Muli 
  - font size: 2rem
  - letter space: 0.1rem
  - uppercase

`The Study of Life` Title Text: 
  - font family: IBM Plex Sans
  - font size: 3.5rem
  - line height: 3rem 
  - font weight: lighter 

## Splash Image
- [Reference Image](css-assessment/img/SplashImg.png)
- Element container selector: `div.os-figure.has-splash`

Container: 
 - margin bottom: 2rem

Left color block:
  - background color: #0074BC
  - width: 8.65in

Splash Image: 
  - width: 8.15in

Caption: 
  - padding top: 1rem 
  - padding bottom: 2rem
  - background color: #EEEAE0
  - font family: IBM Plex Sans

`Figure 1.1` Text:
  - color: #C31427
  - font family: Muli 
  - font weight: bold

## Introduction Paragraph 
- [Reference Image]()
- Element container selector: `.intro-body`

Paragraph:
 - margin bottom: .7rem

`Introduction` title text:
  - uppercase 
  - font weight: 700
  - font size: 12px

"Chapter Outline" Title Text: 
  - border bottom: white 1px solid
  - line height 1.5rem

Chapter Outline:
  - background color: #0074BC
  - font family: IBM Plex Sans 
  - font size: 1rem 
  - font weight: 500
  - width: 2.15in
  - margin right: -1.2rem
  - margin left: 1.5rem
  - padding top, bottom, left: 1.5rem
  - color: white


## Learning Objectives 
Element container selector: `[data-type="page"].chapter-content-module`

  Section Title `1.1 The Science of Biology` 
  - color: #0074BC
  - font: Muli
  - font size: 1.7rem 
  - line height: 1.5rem 
  
  Subtile `By the end of this section-` 
  - same as section title but italic 
  
  Unordered List 
  - font: Muli 
  - font size: 1rem
  - line height: 1.5rem





