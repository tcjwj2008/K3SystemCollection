/*请在测试帐套进行测试，确认没有问题，再在正式帐套尝试。
请在正式帐套尝试前，先备份正式帐套。 1、举个例子，客户应收管理、应付管理，结账到 2017 年 12 期。
现在发现财务总账在 2017 年 5 期，凭证转-1 的币别，需要由美元改为人民币。
于是客户把总账反结账到 2017 年 5 期，然后把凭证币别改为人民币，重新调汇时，提示
“应收应付还未调汇，请先在应收应付调汇”。
解决方法是：反结账应收应付账期到 2017 年 5 期。 2、客户端应收应付反结账确实很麻烦！
通过客户端反结账的话，需要删除 2017 年 6 期至 12 期的所有应收应付生成的凭证、核销关
系，工作量蛮大的。
有些客户的财务比较强势，主观能动性较强，他们自己不怕麻烦去客户端反结账删除凭证。
有些客户一听说要增长他们的工作量，就像老鼠见到猫一样，死活不愿意，老想着是不是后
台能改。。。
3、好吧，通过打听，确实后台能改！ 用 sql 语句修改应收应付当前账期，且删除 6-12 月往来余额数据。*/
--修改应收管理的账期
UPDATE  t_RP_SystemProfile
SET     FValue = '5'
WHERE   FCategory = 'ARP'
        AND FKey = 'FARCurPeriod';
UPDATE  t_RP_SystemProfile
SET     FValue = '2017'
WHERE   FCategory = 'ARP'
        AND FKey = 'FARCurYear';
--删除应收管理的 6-12 月往来余额数据。
--只要大于 2017 年 5 期的应收往来余额数据都要删除
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2018
        AND FPeriod = 1
        AND FRP = 1; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 12
        AND FRP = 1; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 11
        AND FRP = 1; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 10
        AND FRP = 1; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 9
        AND FRP = 1; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 8
        AND FRP = 1; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 7
        AND FRP = 1; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 6
        AND FRP = 1;
--修改应付管理的账期
UPDATE  t_RP_SystemProfile
SET     FValue = '5'
WHERE   FCategory = 'ARP'
        AND FKey = 'FAPCurPeriod';
UPDATE  t_RP_SystemProfile
SET     FValue = '2017'
WHERE   FCategory = 'ARP'
        AND FKey = 'FAPCurYear';
--删除应付管理的 6-12 月往来余额数据。
--只要大于 2017 年 5 期的应付往来余额数据都要删除
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2018
        AND FPeriod = 1
        AND FRP = 0; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 12
        AND FRP = 0; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 11
        AND FRP = 0; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 10
        AND FRP = 0; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 9
        AND FRP = 0;
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 8
        AND FRP = 0; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 7
        AND FRP = 0; 
DELETE  FROM t_RP_ContactBal
WHERE   FYear = 2017
        AND FPeriod = 6
        AND FRP = 0;

/*这时候应收应付的账期就变成 2017 年 5 期，问题处理完以后，再通过正常的结账，就可以
把账期结回去了。
反调汇步骤：应收应付在帐表-调汇记录，过滤 2017 年 12 期调汇记录，鼠标左键双击选中，
点反调汇按钮。依次过滤 11 期，10 期至 6 期记录进行反调汇。
其他报错：结账时，对账检查提示“预收冲应收[XYSD000038][核销序号：2114]：没有生成
转账凭证”
解决：将应收款管理的系统参数中的【预收冲应收需要生成转账凭证】的参数的勾选取消。
*/