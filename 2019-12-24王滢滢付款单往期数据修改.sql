--�޸�Ӧ�����������
Update t_RP_SystemProfile Set FValue = '11' Where FCategory = 'ARP' And FKey = 'FAPCurPeriod';
--Update t_RP_SystemProfile Set FValue = '2017' Where FCategory = 'ARP' And FKey ='FAPCurYear';
--ɾ��Ӧ������� 6-12 ������������ݡ�
--ֻҪ���� 2017 �� 5 �ڵ�Ӧ������������ݶ�Ҫɾ��
Delete from t_RP_ContactBal Where FYear = 2019 And FPeriod = 12 and FRP=0