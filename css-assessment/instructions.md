Hello! 
Thank you for taking the time to complete this assessment. 

If you have any questions, please feel free to email BrittanyJ at bj20@rice.edu. 

# Instructions

Use sass or css to style the book content provided in `biology.xhtml` so it matches the example page in the reference image [here](css-assessment/img/FullPage.png) while following the design specificiations below. 

Use PrinceXML to generate a styled PDF using the provided book content and your style, and place that PDF of your final design in the `./final-design` folder.

When you are finished with the assement, push your changes to your forked repository and email BrittanyJ at bj20@rice.edu with a link to the forked repo. 

- PrinceXML installation documentation can be found [here](https://www.princexml.com/doc/installing/).
- Instruction on how to generate a styled PDF using PrinceXML can be found [here](https://www.princexml.com/doc/command-line/).

### Tips
- Feel free to use your web browser's dev tools inspector during developement as you normally would, but keep in mind that your final output is going to be a PDF not the web.
- The position and size of styled content in your browser will differ from the content in the PDF.
- It is recommened to regularly check both the browser and PDF output to ensure that your style is appearing as you intend in the PDF.
- The `Element container selector`'s listed below are provided to help you identify which item on the page is being referenced in the specs. Be warned that this does not necessarily mean that the styles provided below should be directtly applied to that selector. (For example, the `Element container selector` may contain child elements that the properties provided can be applied to.)
- Questions are welcomed and encouraged. Remember that you can email BrittanyJ at bj20@rice.edu.

## More Context

For us, the purpose of this task is to gauge your profiency with CSS, Git/Github, and the command line. 
For you, it gives a glimpse of the type of work you would be doing as a memeber of the styles team. 

When creating new styles for books, we are typicaly given a suite of design specifications (e.g. font size, weight, color, etc.) but there are still many CSS properties that you must come up with yourself to acheive the desired visual effect. 

A broad overview of a typical workflow for implementing a new design is as follows: 

- New design is presented to the team by a product manager via Zenhub Card (GitHub Issue).
- A developer on the styles team reviews the card and asks any inital questions that they might have about the design and specs provided.
- The developer will implement the style, sticking as closely as possible to the design specs provided and incorporating any additional information given by the product manager.
- The developer submits a screenshot of their final implementation to the product manager for design review and the product manager provides feedback.
- Iterate until finished!
 
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





