namespace UnfoldingOfGoods
{
    partial class FormOptions
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;
        private System.Windows.Forms.MainMenu mainMenu1;

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
            this.mainMenu1 = new System.Windows.Forms.MainMenu();
            this.edtServer = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.edtPort = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.edtTimeOut = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.edtLocation = new System.Windows.Forms.TextBox();
            this.btnSave = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // edtServer
            // 
            this.edtServer.Location = new System.Drawing.Point(13, 35);
            this.edtServer.Name = "edtServer";
            this.edtServer.Size = new System.Drawing.Size(208, 23);
            this.edtServer.TabIndex = 0;
            // 
            // label1
            // 
            this.label1.Location = new System.Drawing.Point(13, 12);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(157, 20);
            this.label1.Text = "Сервер:";
            // 
            // label2
            // 
            this.label2.Location = new System.Drawing.Point(13, 72);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(157, 20);
            this.label2.Text = "Порт:";
            // 
            // edtPort
            // 
            this.edtPort.Location = new System.Drawing.Point(13, 95);
            this.edtPort.Name = "edtPort";
            this.edtPort.Size = new System.Drawing.Size(208, 23);
            this.edtPort.TabIndex = 3;
            // 
            // label3
            // 
            this.label3.Location = new System.Drawing.Point(13, 135);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(157, 20);
            this.label3.Text = "Таймаут:";
            // 
            // edtTimeOut
            // 
            this.edtTimeOut.Location = new System.Drawing.Point(13, 158);
            this.edtTimeOut.Name = "edtTimeOut";
            this.edtTimeOut.Size = new System.Drawing.Size(208, 23);
            this.edtTimeOut.TabIndex = 6;
            // 
            // label4
            // 
            this.label4.Location = new System.Drawing.Point(13, 198);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(157, 20);
            this.label4.Text = "Склад:";
            // 
            // edtLocation
            // 
            this.edtLocation.Location = new System.Drawing.Point(13, 221);
            this.edtLocation.Name = "edtLocation";
            this.edtLocation.Size = new System.Drawing.Size(208, 23);
            this.edtLocation.TabIndex = 9;
            // 
            // btnSave
            // 
            this.btnSave.Location = new System.Drawing.Point(67, 260);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(88, 20);
            this.btnSave.TabIndex = 11;
            this.btnSave.Text = "Сохранить";
            this.btnSave.Click += new System.EventHandler(this.btnSave_Click);
            // 
            // FormOptions
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(96F, 96F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Dpi;
            this.AutoScroll = true;
            this.ClientSize = new System.Drawing.Size(638, 455);
            this.Controls.Add(this.btnSave);
            this.Controls.Add(this.label4);
            this.Controls.Add(this.edtLocation);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.edtTimeOut);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.edtPort);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.edtServer);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "FormOptions";
            this.Text = "Настройки";
            this.TopMost = true;
            this.WindowState = System.Windows.Forms.FormWindowState.Maximized;
            this.Load += new System.EventHandler(this.frmOptions_Load);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TextBox edtServer;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.TextBox edtPort;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox edtTimeOut;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox edtLocation;
        private System.Windows.Forms.Button btnSave;
    }
}