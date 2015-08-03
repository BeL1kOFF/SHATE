using System;

namespace UnfoldingOfGoods.Logic.Objects
{
    public class ObjectActivityLine
    {

        private Int32 FId_ActivityLine;
        private String FBinCode;
        private Int32 FProcessedQty;
        private Int32 FId_PlacementActivityLine;

        public ObjectActivityLine(Int32 aId_ActivityLine, String aBinCode, Int32 aProcessedQty, Int32 aId_PlacementActivityLine)
        {
            FId_ActivityLine = aId_ActivityLine;
            FBinCode = aBinCode;
            FProcessedQty = aProcessedQty;
            FId_PlacementActivityLine = aId_PlacementActivityLine;
        }

        public Int32 Id_ActivityLine { get { return FId_ActivityLine; } }
        public String BinCode { get { return FBinCode; } }
        public Int32 ProcessedQty { get { return FProcessedQty; } }
        public Int32 Id_PlacementActivityLine { get { return FId_PlacementActivityLine; } }

    }
}