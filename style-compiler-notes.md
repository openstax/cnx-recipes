- Generating the CSS takes a long time, even when running `PLATFORM=pdf node ./styles/build/build.js ./styles/books/chemistry/book.scss ./styles/output/chemistry-pdf.css`
When running `./script/run ./script/build-styles`, one has time to go do the dishes, read a book and finish it. It's not very efficient, especially when it needs to be done several times in a row. 

- Troubleshooting components/shapes created by someone else is very time consuming, especially when not all targets have been set. One must spend quite a bit of time studying the components before being able to add/modify. Sometimes, the naming convention do not reflect the selector, making the process of finding and fixing bugs difficult. 

- This might be a good thing but it's impossible to create a set of components/spaces without solid planning for all the pieces that will be needed. 

- Not having a common base for similar components creates a lot of copy and paste. It also doesn't encourage consistency between different components or reusability. 

- Troubleshooting the CSS output is not easy, one must rely on reading the CSS output to verify the results

- If a component is mispelled in the shapes, the framework fails silently. 

- Generally, implementing styles feels more complicated than needed. A flat CSS must be created first, if not, the process for creating one selector/set of properties pairing is time consuming. Additionally, there isn't a way to create temporary values for testing purposes. A component and a shape must be created just to target one selector. 

- We don't support closures or access to variables in spaces, so trying to get reusability within a DESIGN is extremely difficult

- If two spaces are nearly identical and we want to exchange a component deep in the tree, you have to repeat everything up to the point where you exchange the component which seems unecessary
