using System;

namespace UnfoldingOfGoods.Logic.Pick
{
    public interface IPick
    {
        Boolean IsCorrectQuantity();
        void ChangeQuantity();
        Boolean ShowDialog();
    }
}