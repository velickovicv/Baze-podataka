using System;
using System.Data;
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

                // 3. Pravimo upit
                string strSQL = "SELECT POZICIJA.NAZIV AS POZICIJA, SEKTOR.NAZIV AS SEKTOR " +
                                "FROM ZAPOSLENI INNER JOIN POZICIJA ON ZAPOSLENI.ID = POZICIJA.ZAPOSLENI_ID " +
                                "INNER JOIN SEKTOR ON POZICIJA.SEKTOR_ID = SEKTOR.ID " +
                                "WHERE ZAPOSLENI.ID = :idZaposlenog";

                // 4. Unosimo ID zaposlenog
                Console.WriteLine("Unesite ID zaposlenog:");
                int idZaposlenog = int.Parse(Console.ReadLine());

                // 5. Postavljamo most preko DataAdaptera
                OracleDataAdapter da = new OracleDataAdapter(strSQL, con);
                da.SelectCommand.Parameters.Add(new OracleParameter("idZaposlenog", idZaposlenog));

                // 6. Popunjavamo tabelu preko DataSet-a
                DataSet ds = new DataSet();
                da.Fill(ds, "POZICIJE_I_SEKTORI");

                // 7. Ispisujemo rezultate
                foreach (DataRow r in ds.Tables["POZICIJE_I_SEKTORI"].Rows)
                {
                    string nazivPozicije = (string)r["POZICIJA"];
                    string nazivSektora = (string)r["SEKTOR"];
                    Console.WriteLine($"Pozicija: {nazivPozicije}, Sektor: {nazivSektora}");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Došlo je do greške prilikom povezivanja baze podataka! " + ex.Message);
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
