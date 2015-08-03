namespace UnfoldingOfGoods
{
    partial class FormMain
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.pnlMain = new System.Windows.Forms.Panel();
            this.cmbBarCode = new System.Windows.Forms.ComboBox();
            this.edtNumber = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.edtName = new System.Windows.Forms.TextBox();
            this.lbUserCode = new System.Windows.Forms.Label();
            this.edtUserCode = new System.Windows.Forms.TextBox();
            this.pnlButton = new System.Windows.Forms.Panel();
            this.btnSubmit = new System.Windows.Forms.Button();
            this.pnlDetail = new System.Windows.Forms.Panel();
            this.pnlGrid = new System.Windows.Forms.Panel();
            this.grDetail = new System.Windows.Forms.DataGrid();
            this.bsDetail = new System.Windows.Forms.BindingSource(this.components);
            this.tblStyle = new System.Windows.Forms.DataGridTableStyle();
            this.colItemNo2 = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colBinCode = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colQtyPlacement = new System.Windows.Forms.DataGridTextBoxColumn();
            this.colProcessedQty = new System.Windows.Forms.DataGridTextBoxColumn();
            this.pnlMemo = new System.Windows.Forms.Panel();
            this.mDetails = new System.Windows.Forms.TextBox();
            this.pnlMain.SuspendLayout();
            this.pnlButton.SuspendLayout();
            this.pnlDetail.SuspendLayout();
            this.pnlGrid.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.bsDetail)).BeginInit();
            this.pnlMemo.SuspendLayout();
            this.SuspendLayout();
            // 
            // pnlMain
            // 
            this.pnlMain.Controls.Add(this.cmbBarCode);
            this.pnlMain.Controls.Add(this.edtNumber);
            this.pnlMain.Controls.Add(this.label1);
            this.pnlMain.Controls.Add(this.edtName);
            this.pnlMain.Controls.Add(this.lbUserCode);
            this.pnlMain.Controls.Add(this.edtUserCode);
            this.pnlMain.Dock = System.Windows.Forms.DockStyle.Top;
            this.pnlMain.Location = new System.Drawing.Point(0, 0);
            this.pnlMain.Name = "pnlMain";
            this.pnlMain.Size = new System.Drawing.Size(638, 100);
            // 
            // cmbBarCode
            // 
            this.cmbBarCode.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.cmbBarCode.BackColor = System.Drawing.SystemColors.InactiveBorder;
            this.cmbBarCode.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDown;
            this.cmbBarCode.Enabled = false;
            this.cmbBarCode.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.cmbBarCode.Location = new System.Drawing.Point(94, 50);
            this.cmbBarCode.Name = "cmbBarCode";
            this.cmbBarCode.Size = new System.Drawing.Size(541, 19);
            this.cmbBarCode.TabIndex = 2;
            this.cmbBarCode.SelectedIndexChanged += new System.EventHandler(this.cmbBarCode_SelectedIndexChanged);
            this.cmbBarCode.KeyUp += new System.Windows.Forms.KeyEventHandler(this.cmbBarCode_KeyUp);
            // 
            // edtNumber
            // 
            this.edtNumber.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.edtNumber.BackColor = System.Drawing.SystemColors.InactiveBorder;
            this.edtNumber.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.edtNumber.Location = new System.Drawing.Point(94, 75);
            this.edtNumber.Name = "edtNumber";
            this.edtNumber.ReadOnly = true;
            this.edtNumber.Size = new System.Drawing.Size(541, 19);
            this.edtNumber.TabIndex = 3;
            // 
            // label1
            // 
            this.label1.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.label1.Location = new System.Drawing.Point(3, 53);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(92, 19);
            this.label1.Text = "Номер приемки:";
            // 
            // edtName
            // 
            this.edtName.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.edtName.BackColor = System.Drawing.SystemColors.InactiveBorder;
            this.edtName.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.edtName.Location = new System.Drawing.Point(94, 25);
            this.edtName.Name = "edtName";
            this.edtName.ReadOnly = true;
            this.edtName.Size = new System.Drawing.Size(541, 19);
            this.edtName.TabIndex = 1;
            // 
            // lbUserCode
            // 
            this.lbUserCode.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.lbUserCode.Location = new System.Drawing.Point(3, 3);
            this.lbUserCode.Name = "lbUserCode";
            this.lbUserCode.Size = new System.Drawing.Size(92, 19);
            this.lbUserCode.Text = "Код сотрудника:";
            // 
            // edtUserCode
            // 
            this.edtUserCode.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Left)
                        | System.Windows.Forms.AnchorStyles.Right)));
            this.edtUserCode.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.edtUserCode.Location = new System.Drawing.Point(94, 3);
            this.edtUserCode.Name = "edtUserCode";
            this.edtUserCode.Size = new System.Drawing.Size(541, 19);
            this.edtUserCode.TabIndex = 0;
            this.edtUserCode.KeyUp += new System.Windows.Forms.KeyEventHandler(this.edtUserCode_KeyUp);
            // 
            // pnlButton
            // 
            this.pnlButton.Controls.Add(this.btnSubmit);
            this.pnlButton.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.pnlButton.Location = new System.Drawing.Point(0, 430);
            this.pnlButton.Name = "pnlButton";
            this.pnlButton.Size = new System.Drawing.Size(638, 25);
            // 
            // btnSubmit
            // 
            this.btnSubmit.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnSubmit.Enabled = false;
            this.btnSubmit.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.btnSubmit.Location = new System.Drawing.Point(547, 2);
            this.btnSubmit.Name = "btnSubmit";
            this.btnSubmit.Size = new System.Drawing.Size(88, 20);
            this.btnSubmit.TabIndex = 4;
            this.btnSubmit.Text = "Разместить";
            this.btnSubmit.Click += new System.EventHandler(this.btnSubmit_Click);
            // 
            // pnlDetail
            // 
            this.pnlDetail.Controls.Add(this.pnlGrid);
            this.pnlDetail.Controls.Add(this.pnlMemo);
            this.pnlDetail.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pnlDetail.Location = new System.Drawing.Point(0, 100);
            this.pnlDetail.Name = "pnlDetail";
            this.pnlDetail.Size = new System.Drawing.Size(638, 330);
            // 
            // pnlGrid
            // 
            this.pnlGrid.BackColor = System.Drawing.SystemColors.Desktop;
            this.pnlGrid.Controls.Add(this.grDetail);
            this.pnlGrid.Dock = System.Windows.Forms.DockStyle.Fill;
            this.pnlGrid.Location = new System.Drawing.Point(0, 0);
            this.pnlGrid.Name = "pnlGrid";
            this.pnlGrid.Size = new System.Drawing.Size(638, 275);
            // 
            // grDetail
            // 
            this.grDetail.BackgroundColor = System.Drawing.Color.FromArgb(((int)(((byte)(128)))), ((int)(((byte)(128)))), ((int)(((byte)(128)))));
            this.grDetail.Dock = System.Windows.Forms.DockStyle.Fill;
            this.grDetail.Location = new System.Drawing.Point(0, 0);
            this.grDetail.Name = "grDetail";
            this.grDetail.Size = new System.Drawing.Size(638, 275);
            this.grDetail.TabIndex = 2;
            this.grDetail.TableStyles.Add(this.tblStyle);
            this.grDetail.CurrentCellChanged += new System.EventHandler(this.grDetail_CurrentCellChanged);
            // 
            // tblStyle
            // 
            this.tblStyle.GridColumnStyles.Add(this.colItemNo2);
            this.tblStyle.GridColumnStyles.Add(this.colBinCode);
            this.tblStyle.GridColumnStyles.Add(this.colQtyPlacement);
            this.tblStyle.GridColumnStyles.Add(this.colProcessedQty);
            this.tblStyle.MappingName = "Detail";
            // 
            // colItemNo2
            // 
            this.colItemNo2.Format = "";
            this.colItemNo2.FormatInfo = null;
            this.colItemNo2.HeaderText = "Товар";
            this.colItemNo2.MappingName = "ItemNo2";
            // 
            // colBinCode
            // 
            this.colBinCode.Format = "";
            this.colBinCode.FormatInfo = null;
            this.colBinCode.HeaderText = "Ячейка";
            this.colBinCode.MappingName = "BinCode";
            // 
            // colQtyPlacement
            // 
            this.colQtyPlacement.Format = "";
            this.colQtyPlacement.FormatInfo = null;
            this.colQtyPlacement.HeaderText = "Кол-во";
            this.colQtyPlacement.MappingName = "QtyPlacement";
            // 
            // colProcessedQty
            // 
            this.colProcessedQty.Format = "";
            this.colProcessedQty.FormatInfo = null;
            this.colProcessedQty.HeaderText = "Обработано";
            this.colProcessedQty.MappingName = "ProcessedQty";
            // 
            // pnlMemo
            // 
            this.pnlMemo.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.pnlMemo.Controls.Add(this.mDetails);
            this.pnlMemo.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.pnlMemo.Location = new System.Drawing.Point(0, 275);
            this.pnlMemo.Name = "pnlMemo";
            this.pnlMemo.Size = new System.Drawing.Size(638, 55);
            // 
            // mDetails
            // 
            this.mDetails.Dock = System.Windows.Forms.DockStyle.Fill;
            this.mDetails.Font = new System.Drawing.Font("Tahoma", 8F, System.Drawing.FontStyle.Regular);
            this.mDetails.Location = new System.Drawing.Point(0, 0);
            this.mDetails.Multiline = true;
            this.mDetails.Name = "mDetails";
            this.mDetails.ReadOnly = true;
            this.mDetails.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.mDetails.Size = new System.Drawing.Size(638, 55);
            this.mDetails.TabIndex = 3;
            // 
            // FormMain
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(638, 455);
            this.Controls.Add(this.pnlDetail);
            this.Controls.Add(this.pnlButton);
            this.Controls.Add(this.pnlMain);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "FormMain";
            this.Text = "Раскладка товара";
            this.TopMost = true;
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.frmMain_Load);
            this.Closing += new System.ComponentModel.CancelEventHandler(this.FormMain_Closing);
            this.pnlMain.ResumeLayout(false);
            this.pnlButton.ResumeLayout(false);
            this.pnlDetail.ResumeLayout(false);
            this.pnlGrid.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.bsDetail)).EndInit();
            this.pnlMemo.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel pnlMain;
        private System.Windows.Forms.Panel pnlButton;
        private System.Windows.Forms.Panel pnlDetail;
        private System.Windows.Forms.Label lbUserCode;
        private System.Windows.Forms.TextBox edtUserCode;
        private System.Windows.Forms.TextBox edtName;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox edtNumber;
        private System.Windows.Forms.Button btnSubmit;
        private System.Windows.Forms.ComboBox cmbBarCode;
        private System.Windows.Forms.Panel pnlMemo;
        private System.Windows.Forms.Panel pnlGrid;
        private System.Windows.Forms.TextBox mDetails;
        private System.Windows.Forms.DataGrid grDetail;
        private System.Windows.Forms.BindingSource bsDetail;
        private System.Windows.Forms.DataGridTableStyle tblStyle;
        private System.Windows.Forms.DataGridTextBoxColumn colItemNo2;
        private System.Windows.Forms.DataGridTextBoxColumn colBinCode;
        private System.Windows.Forms.DataGridTextBoxColumn colQtyPlacement;
        private System.Windows.Forms.DataGridTextBoxColumn colProcessedQty;
    }
}

