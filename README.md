# Idle Hands are the **Developer's Workshop**

&nbsp;

## With little more than a few key strokes and restarts, a suite of essential developer productivity software such as WSL, Github, VSCode, Docker Desktop, Python and more will be installed giving you a sandboxed virtual environment on your Windows 10+ machine in a matter of minutes. Included is a tool called the Devel's Playground that lets you choose from thousands of highly customizable Docker images straight from the Docker Hub. It will automatically install a lightweight image for you to try at the end of the install. These custom images [(described further down here)](https://github.com/kindtek/devels-workshop#image-versions) were built with the Docker files hosted on this repo and are easily customizable for yourself

&nbsp;

### Easy as 1, 2, 4

1. Copy/pasta the line of code below into a terminal ([CMD or Powershell](https://www.wikihow.com/Open-Terminal-in-Windows))
2. Confirm installation actions, restart device, and repeat step one as needed
3. ??
4. Profit

```bat
powershell.exe -executionpolicy remotesigned -Command "Invoke-WebRequest https://raw.githubusercontent.com/kindtek/powerhell-remote/devels-workshop/download-everything-and-install.ps1 -OutFile install-kindtek-devels-workshop.ps1; powershell.exe -executionpolicy remotesigned -File install-kindtek-devels-workshop.ps1"
```

&nbsp;

## When set up is complete, there will be an option to launch the Devel's Playground WSL Docker import tool. Not only does it make it easy for you to import your own custom Docker images onto WSL, it demonstrates how easy it is to wrap this portable containerized developer environment around a separate standalone repo

<!-- ###### also found in [[copypasta.cmd](scripts/powerhell-remote/copypasta.cmd)] -->

&nbsp;

---

### **Instructions for importing images from [hub.docker.com](https://hub.docker.com/) into WSL are [found here](https://github.com/kindtek/devels-playground)**

&nbsp;

---

#### MIT License

Copyright (c) 2023 KINDTEK, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

&nbsp;
