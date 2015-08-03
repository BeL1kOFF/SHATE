using System;

namespace UnfoldingOfGoods.Logic.Pick
{
    public class ProcessedPick : IPick
    {

        private Int32 FId_ActivityLine;
        private Int32 FQuantity;

        public ProcessedPick(Int32 aId, Int32 aQuantity)
        {
            FId_ActivityLine = aId;
            FQuantity = aQuantity;
        }

        private String Message
        {
            get { return "Невозможно уменьшить кол-во."; }
        }

        public Boolean IsCorrectQuantity()
        {
            Int32 activeCount = ClassFactory.DataBase.GetCountCurrentActivityLine(FId_ActivityLine);
            return ((activeCount - FQuantity) >= 0);
        }

        public void ChangeQuantity()
        {
            ClassFactory.DataBase.ChangeCountDec(FId_ActivityLine, FQuantity);
        }

        public Boolean ShowDialog()
        {
            MyClass.ShowWarning(Message);
            return false;
        }

    }
}