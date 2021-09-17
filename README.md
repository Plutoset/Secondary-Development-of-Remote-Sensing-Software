# Secondary-Development-of-Remote-Sensing-Software
This repo is for my course Secondary Development of Remote Sensing Software (2021).
此库为我的课程遥感软件二次开发(2021)的作业库。
### 模板使用注意事项
- 请下载并且确保当前编译的.tex的文件夹路径下包括rsreport.cls文件
- 请选择rsreport作为文档类型，即开头语句为`\documentclass{rsreport}`
- 请在`\begin{document}`开始前填写你的实习报告具体信息，具体案例可以查看example.tex文件。
- 请在`\begin{document}`后添加`\maketitle`一行。
- 请使用XeLaTex编译器进行编译
- 字体库为[思源宋体](https://github.com/adobe-fonts/source-han-serif)和[思源黑体](https://github.com/adobe-fonts/source-han-sans)
- 所需下载的字体为[SourceHanSerifSC-Regular.otf](https://github.com/adobe-fonts/source-han-serif/blob/release/OTF/SimplifiedChinese/SourceHanSerifSC-Regular.otf), [SourceHanSerifSC-Bold.otf](https://github.com/adobe-fonts/source-han-serif/blob/release/OTF/SimplifiedChinese/SourceHanSerifSC-Bold.otf), [SourceHanSans-Regular.otf](https://github.com/adobe-fonts/source-han-sans/blob/release/OTF/SimplifiedChinese/SourceHanSansSC-Regular.otf), 如需更替字体可修改cls的216-224行。

- 已加载的宏包

    zhnumber    geometry    titlesec    titletoc
    
    amsmath     amsfonts    amssymb     bm
    
    amsthm      xcolor      graphicx    float
    
    array       booktabs    longtable   tabularx
    
    multirow    bigstrut    diagbox     bigdelim
    
    cprotect    listings    url         algorithm
    
    enumitem    placeins    xeCJK       algpseudocode
    
    fancyhdr    ulem        hyperref    algorithmicx
    
    caption     tocloft     fontspec    indentfirst
    
    xunicode    enumitem    xpatch      etoolbox
