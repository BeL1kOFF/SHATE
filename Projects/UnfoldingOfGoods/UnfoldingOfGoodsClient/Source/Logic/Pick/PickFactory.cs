using System;

namespace UnfoldingOfGoods.Logic.Pick
{
    public delegate IPick PickInstanceDelegate(Int32 aId, Int32 aQuantity);

    public static class PickFactory
    {

        public static IPick Locate(Int32 aId, Int32 aQuantity)
        {
            return new LocatePick(aId, aQuantity);
        }

        public static IPick Processed(Int32 aId, Int32 aQuantity)
        {
            return new ProcessedPick(aId, aQuantity);
        }

    }
}