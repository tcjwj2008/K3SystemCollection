/*���ڲ������׽��в��ԣ�ȷ��û�����⣬������ʽ���׳��ԡ�
������ʽ���׳���ǰ���ȱ�����ʽ���ס� 1���ٸ����ӣ��ͻ�Ӧ�չ���Ӧ���������˵� 2017 �� 12 �ڡ�
���ڷ��ֲ��������� 2017 �� 5 �ڣ�ƾ֤ת-1 �ıұ���Ҫ����Ԫ��Ϊ����ҡ�
���ǿͻ������˷����˵� 2017 �� 5 �ڣ�Ȼ���ƾ֤�ұ��Ϊ����ң����µ���ʱ����ʾ
��Ӧ��Ӧ����δ���㣬������Ӧ��Ӧ�����㡱��
��������ǣ�������Ӧ��Ӧ�����ڵ� 2017 �� 5 �ڡ� 2���ͻ���Ӧ��Ӧ��������ȷʵ���鷳��
ͨ���ͻ��˷����˵Ļ�����Ҫɾ�� 2017 �� 6 ���� 12 �ڵ�����Ӧ��Ӧ�����ɵ�ƾ֤��������
ϵ������������ġ�
��Щ�ͻ��Ĳ���Ƚ�ǿ�ƣ������ܶ��Խ�ǿ�������Լ������鷳ȥ�ͻ��˷�����ɾ��ƾ֤��
��Щ�ͻ�һ��˵Ҫ�������ǵĹ������������������èһ�������Ը�⣬�������ǲ��Ǻ�
̨�ܸġ�����
3���ðɣ�ͨ��������ȷʵ��̨�ܸģ� �� sql ����޸�Ӧ��Ӧ����ǰ���ڣ���ɾ�� 6-12 ������������ݡ�*/
--�޸�Ӧ�չ��������
UPDATE  t_RP_SystemProfile
SET     FValue = '5'
WHERE   FCategory = 'ARP'
        AND FKey = 'FARCurPeriod';
UPDATE  t_RP_SystemProfile
SET     FValue = '2017'
WHERE   FCategory = 'ARP'
        AND FKey = 'FARCurYear';
--ɾ��Ӧ�չ���� 6-12 ������������ݡ�
--ֻҪ���� 2017 �� 5 �ڵ�Ӧ������������ݶ�Ҫɾ��
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
--�޸�Ӧ�����������
UPDATE  t_RP_SystemProfile
SET     FValue = '5'
WHERE   FCategory = 'ARP'
        AND FKey = 'FAPCurPeriod';
UPDATE  t_RP_SystemProfile
SET     FValue = '2017'
WHERE   FCategory = 'ARP'
        AND FKey = 'FAPCurYear';
--ɾ��Ӧ������� 6-12 ������������ݡ�
--ֻҪ���� 2017 �� 5 �ڵ�Ӧ������������ݶ�Ҫɾ��
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

/*��ʱ��Ӧ��Ӧ�������ھͱ�� 2017 �� 5 �ڣ����⴦�����Ժ���ͨ�������Ľ��ˣ��Ϳ���
�����ڽ��ȥ�ˡ�
�����㲽�裺Ӧ��Ӧ�����ʱ�-�����¼������ 2017 �� 12 �ڵ����¼��������˫��ѡ�У�
�㷴���㰴ť�����ι��� 11 �ڣ�10 ���� 6 �ڼ�¼���з����㡣
������������ʱ�����˼����ʾ��Ԥ�ճ�Ӧ��[XYSD000038][������ţ�2114]��û������
ת��ƾ֤��
�������Ӧ�տ�����ϵͳ�����еġ�Ԥ�ճ�Ӧ����Ҫ����ת��ƾ֤���Ĳ����Ĺ�ѡȡ����
*/