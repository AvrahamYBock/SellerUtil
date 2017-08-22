<?php include "top.php"; ?>
    <form method="Post">
        <button type="submit" class="form-group pull-right">Save All Changes</button>
        <table class="table table-bordered table-striped">
            <thead>
                <tr>
                    <th>sku</th>                
                    <th>description</th>
                    <th>cost price</th>
                </tr>
            </thead>
            <tbody>
                <?php foreach($skusPrices as $skuPrice):?>
                    <tr>
                        <td class = "col-md-3"><?= $skuPrice[0] ?></td>
                        <td class = "col-md-7"><?= $skuPrice[1] ?></td>
                        <td class = "col-xs-3 col-md-2">
                            <input name="<?= $skuPrice[0] ?>" value="<?= $skuPrice[2] ?>">
                        </td>
                    </tr>
                <?php endforeach ?>
            </tbody>
        </table>        
        <button type="submit" class="pull-right">Save All Changes</button>
    </form>
<?php include "bottom.php"; ?>