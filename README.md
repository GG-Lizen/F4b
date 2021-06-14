# F4b
## 实验F4b 8位12指令微程序CPU设计

参考[ch05.ppt](https://courses.gdut.edu.cn/pluginfile.php/138337/mod_folder/content/0/ch05.ppt?forcedownload=1), [ch06.ppt](https://courses.gdut.edu.cn/pluginfile.php/138337/mod_folder/content/0/ch06.ppt?forcedownload=1), 跑通范例 [8位微程序CPU设计_包含程序.12条指令.doc](https://courses.gdut.edu.cn/mod/resource/view.php?id=15078)。
对进行波形图中的逐条指令、逐个阶段、逐个操作、逐个部件逐个数据变化的对应关系分析，数据运算过程分析。
按模板提交报告,[18计1-3184001234张三三课程设计5条指令8位CISC.CPU设计.doc](https://courses.gdut.edu.cn/mod/resource/view.php?id=10311)。

bdf和vhd转换
1 图形编辑界面生成.bdf文件
File -> New ->Design Files -> Block Diagram/Schematic File
2 .bdf调用.vhd
由.vhd文件生成.bdf: File -> Create/Update -> Create Symbol Files for Current File
注意： 更新.vhd后要重做上述步骤更新.bdf
.bdf 文件添加到工程后会在器件库的project分支中显示，可直接添加到图形界面.bdf中
3 .vhd调用.bdf
由.bdf 文件生成.vhd文件再调用.vhd文件
打开.bdf文件，保持*.bdf为活动窗口状态，进入编辑状态，File -> Create/Update -> Create VHDL Component Declaration Files for Current File
注意：更新 .bdf之后要重做上述步骤更新.vhd

报告在新云在线填写，文字、代码、表格不得以图片上传, 显示器的内容只能截图，不得手机拍照。
点贴图按钮，可上传jpg，png文件, 其他贴图方式或临时链接丢失图片,按该部分空白处理。
报告不接收文件。
提交完整详细的代码，元件图，测试波形，整个实验各个部分的说明，包括目标，各部分设计细节，测试，测试结果各个位置细节。
