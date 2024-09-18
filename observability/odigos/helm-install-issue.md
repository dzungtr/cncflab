**Describe the bug**
When installing Odigos using Helm, the cleanup job is initiated after all CRD got installed. The job is automatically run and remove all of the CRD. This causes Odiglet, Instrumentor and scheduler are flushed with errors of not finding the required CRD. I rerun the installation few times but still same error. Workaround by deleting the folder clean up in charts template and get the set up to work

**To Reproduce**
Steps to reproduce the behavior:
1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

**Expected behavior**
Helm installation should work out of the box without manual workaround

**Screenshots**
If applicable, add screenshots to help explain your problem.

**Desktop (please complete the following information):**
 - OS: [e.g. iOS]
 - Browser [e.g. chrome, safari]
 - Version [e.g. 22]

**Smartphone (please complete the following information):**
 - Device: [e.g. iPhone6]
 - OS: [e.g. iOS8.1]
 - Browser [e.g. stock browser, safari]
 - Version [e.g. 22]

**Additional context**
Add any other context about the problem here.
