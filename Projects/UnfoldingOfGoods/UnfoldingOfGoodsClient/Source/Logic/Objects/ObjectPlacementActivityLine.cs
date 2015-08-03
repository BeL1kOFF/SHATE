using System;

namespace UnfoldingOfGoods.Logic.Objects
{
    public class ObjectPlacementActivityLine
    {

        private Int32 FId_PlacementActivityLine;
        private String FItemNo;
        private String FItemNo2;
        private String FDescription;
        private String FUnitOfMeasure;
        private Int32 FQtyPlacement;
        private Int32 FProcessedQty;
        private String FBinCode;
        private Int32 FBinContQty;
        private Int32 FLineNo;
        private Int32 FQuantityInPackage;

        public ObjectPlacementActivityLine(Int32 aId_PlacementActivityLine, String aItemNo, String aItemNo2, String aDescription, String aUnitOfMeasure,
            Int32 aQtyPlacement, Int32 aProcessedQty, String aBinCode, Int32 aBinContQty, Int32 aLineNo, Int32 aQuantityInPackage)
        {
            FId_PlacementActivityLine = aId_PlacementActivityLine;
            FItemNo = aItemNo;
            FItemNo2 = aItemNo2;
            FDescription = aDescription;
            FUnitOfMeasure = aUnitOfMeasure;
            FQtyPlacement = aQtyPlacement;
            FProcessedQty = aProcessedQty;
            FBinCode = aBinCode;
            FBinContQty = aBinContQty;
            FLineNo = aLineNo;
            FQuantityInPackage = aQuantityInPackage;
        }

        public Int32 Id_PlacementActivityLine { get { return FId_PlacementActivityLine; } }

        public String ItemNo { get { return FItemNo; } }
        public String ItemNo2 { get { return FItemNo2; } }
        public String Description { get { return FDescription; } }
        public String UnitOfMeasure { get { return FUnitOfMeasure; } }
        public Int32 QtyPlacement { get { return FQtyPlacement; } }
        public Int32 ProcessedQty { get { return FProcessedQty; } }
        public String BinCode { get { return FBinCode; } }
        public Int32 BinContQty { get { return FBinContQty; } }
        public Int32 LineNo { get { return FLineNo; } }
        public Int32 QuantityInPackage { get { return FQuantityInPackage; } }

    }
}