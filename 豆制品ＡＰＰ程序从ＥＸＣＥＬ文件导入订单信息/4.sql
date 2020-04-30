CREATE PROCEDURE ImportAppOrder
AS
    BEGIN

        INSERT  INTO t_order
                ( opener      --操作员		
                  ,
                  ordertime   --订单时间
                  ,
                  remarks     --标识
                  ,
                  state       --状态
                  ,
                  isread ,
                  storeid ,
                  amount ,
                  orderno
                )
                SELECT  NULL ,
                        '2020-03-23 09:13:27.1540000' ,
                        N'手工导入' ,
                        N'签收' ,
                        N'0' ,
                        N'12013' ,
                        N'14.15' ,
                        NULL;


--SELECT  * FROM    t_orderdetail;

        INSERT  INTO t_orderdetail
                ( mainid ,
                  productno ,
                  num ,
                  price ,
                  amount ,
                  kind ,
                  product ,
                  spec ,
                  cmoney ,
                  cunit ,
                  agio ,
                  remarks
                )
                SELECT  N'41559' ,
                        N'1025' ,
                        1 ,
                        0.94999999999999996 ,
                        0.94999999999999996 ,
                        NULL ,
                        N'日本豆腐' ,
                        N'95克' ,
                        N'0.9500000000' ,
                        N'袋4' ,
                        NULL ,
                        N'主推';
            
    END;