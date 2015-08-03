using System;

namespace UnfoldingOfGoods.Logic.Requests
{
    public interface IRequest
    {

        void PrepareMessage();
        void Request(ResponseDelegate aResponseDelegate);
        Boolean ExecuteAfter();

    }
}