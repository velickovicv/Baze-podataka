using System;
using System.Data;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Oracle.DataAccess.Client;

namespace Zadatak
{
    class Program
    {
        static void Main(string[] args)
        {
            // 1. Pravimo konekcioni string
            string conString = "Data Source=160.99.9.63/GISLAB.ni.ac.rs;User Id=S18462;Password=18462;";
            OracleConnection con = null;

            try
            {
                // 2. Pravimo novu konekciju
                con = new OracleConnection(conString);
                con.Open();

                // Definisanje SQL upita
                string strSQL = @"
                    SELECT SPORTISTA.IME, SPORTISTA.PREZIME, SPORTISTA.GRAD 
                    FROM SPORTISTA 
                    INNER JOIN CLAN ON SPORTISTA.ID = CLAN.ID_SPORTISTE 
                    INNER JOIN KLUB ON CLAN.ID_KLUBA = KLUB.ID 
                    WHERE CLAN.TIM = 'PRVI' AND SPORTISTA.GRAD = 'NIS' AND CLAN.ID_KLUBA = :idKluba";

                // Unos ID kluba
                Console.WriteLine("Unesite ID Kluba:");
                int idKluba = int.Parse(Console.ReadLine());

                // 3. Priprema DataAdapter-a
                OracleDataAdapter da = new OracleDataAdapter(strSQL, con);
                da.SelectCommand.Parameters.Add(new OracleParameter("idKluba", idKluba));

                // 4. Kreira se novi DataSet i puni podacima
                DataSet ds = new DataSet();
                da.Fill(ds, "CLANOVI");

                // Ispis podataka
                foreach (DataRow r in ds.Tables["CLANOVI"].Rows)
                {
                    string ime = (string)r["IME"];
                    string prezime = (string)r["PREZIME"];
                    string grad = (string)r["GRAD"];

                    Console.WriteLine($"Ime: {ime}, Prezime: {prezime}, Grad: {grad}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Došlo je do greške: " + ex.Message);
            }
            finally
            {
                if (con != null && con.State == ConnectionState.Open)
                {
                    con.Close();
                }
                con = null;
            }
        }
    }
}
