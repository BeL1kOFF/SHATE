using System;
using System.Linq;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using UnfoldingOfGoods.Logic;

namespace UnfoldingOfGoods
{
    public partial class FormOptions : Form
    {
        public FormOptions()
        {
            InitializeComponent();
        }

        public void LoadOptions()
        {
            edtServer.Text = XmlOptions.Options.Server;
            edtPort.Text = XmlOptions.Options.Port.ToString();
            edtTimeOut.Text = XmlOptions.Options.Timeout.ToString();
            edtLocation.Text = XmlOptions.Options.Location;
        }

        private void frmOptions_Load(object sender, EventArgs e)
        {
            LoadOptions();
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            XmlOptions.Options.Server = edtServer.Text;
            XmlOptions.Options.Port = Convert.ToInt32(edtPort.Text);
            XmlOptions.Options.Timeout = Convert.ToInt32(edtTimeOut.Text);
            XmlOptions.Options.Location = edtLocation.Text;
            XmlOptions.Options.Save();
            Close();
        }
    }
}