using System;

namespace UnfoldingOfGoods.Logic.Pick
{
    public class LocatePick : IPick
    {

        private Int32 FId_PlacementActivityLine;
        private Int32 FQuantity;

        public LocatePick(Int32 aId, Int32 aQuantity)
        {
            FId_PlacementActivityLine = aId;
            FQuantity = aQuantity;
        }

        private String Message
        {
            get { return "Введено превышающее кол-во, подтвердить излишки?"; }
        }

        public Boolean IsCorrectQuantity()
        {
            Int32 activeCount;
            Int32 totalCount;
            Int32 predCount;
            ClassFactory.DataBase.GetCountParamsQty(FId_PlacementActivityLine, out totalCount, out predCount, out activeCount);
            return ((totalCount - predCount - activeCount) >= FQuantity);
        }

        public void ChangeQuantity()
        {
            ClassFactory.DataBase.ChangeCountAdd(FId_PlacementActivityLine, FQuantity);
        }

        public Boolean ShowDialog()
        {
            return MyClass.ShowQuestion(Message);
        }

    }
}