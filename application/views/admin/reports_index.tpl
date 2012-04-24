<form id="report_form" action="index.pl?controller=admin_reports&action=index" method="post">
    <span>[% message %]</span> <br /><br />
    <label for="x_axis">Вертикальная ось</label>
    <select class="axises" id="x_axis" name="x_axis" ></select>
    <label for="x_detalisation">Детализация</label>
    <select id="x_detalisation" name="x_detalisation"></select>
    <br />
    <label for="y_axis">Горизонтальная ось</label>
    <select class="axises" id="y_axis" name="y_axis"></select>
    <label for="y_detalisation">Детализация</label>
    <select id="y_detalisation" name="y_detalisation"></select>
    <br />
    <label for="analyze">Анализировать </label>
    <select id="analyze" name="analyze">
        <option value="price">прибыль</option>
	<option value="count">количество продаж</option>
    </select>
    <label for="aggregation"> по </label>
    <select id="aggregation" name="aggregation">
        <option value="sum">сумме</option>
	<option value="max">максимальному значению</option>
	<option value="min">минимальному значению</option>
	<option value="avg">среднему значению</option>
    </select>
    <br />
    <input type="submit" name="submit" value="Отправить запрос"/>
</form>